package com.example.smart_parking

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "smsChannel"
    private val EVENT_CHANNEL = "smsDeliveryChannel"
    private var eventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Register broadcast receivers for SMS sent and delivered intents
        registerReceiver(smsSentReceiver, IntentFilter("SMS_SENT"))
        registerReceiver(smsDeliveredReceiver, IntentFilter("SMS_DELIVERED"))
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSIMCards" -> {
                    getSIMCards(result)
                }
                "sendSMS" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")
                    val simSlot = call.argument<Int>("simSlot")
                    if (phoneNumber != null && message != null && simSlot != null) {
                        sendSMS(phoneNumber, message, simSlot, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Arguments are null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    private fun getSIMCards(result: MethodChannel.Result) {
        try {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList
            val simList = ArrayList<Map<String, String>>()

            subscriptionInfoList?.forEach {
                val simInfo = mapOf(
                    "carrierName" to (it.carrierName?.toString() ?: "Unknown"),
                    "displayName" to (it.displayName?.toString() ?: "Unknown"),
                    "slotIndex" to it.simSlotIndex.toString()
                )
                simList.add(simInfo)
            }

            result.success(simList)
        } catch (e: Exception) {
            result.error("SIM_FETCH_FAILED", "Failed to fetch SIM cards: ${e.message}", null)
        }
    }

    private fun sendSMS(phoneNumber: String, message: String, simSlot: Int, result: MethodChannel.Result) {
        try {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList

            if (subscriptionInfoList != null && subscriptionInfoList.size > simSlot) {
                val subscriptionInfo = subscriptionInfoList[simSlot]
                val smsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionInfo.subscriptionId)

                val sentIntent = PendingIntent.getBroadcast(this, 0, Intent("SMS_SENT"), 0)
                val deliveredIntent = PendingIntent.getBroadcast(this, 0, Intent("SMS_DELIVERED"), 0)

                smsManager.sendTextMessage(phoneNumber, null, message, sentIntent, deliveredIntent)
                result.success("SMS sent")
            } else {
                result.error("INVALID_SIM_SLOT", "Invalid SIM slot: $simSlot", null)
            }
        } catch (e: Exception) {
            result.error("SMS_SEND_FAILED", "Failed to send SMS: ${e.message}", null)
        }
    }

    private val smsSentReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val status = when (resultCode) {
                RESULT_OK -> "SMS sent"
                SmsManager.RESULT_ERROR_GENERIC_FAILURE -> "Generic failure"
                SmsManager.RESULT_ERROR_NO_SERVICE -> "No service"
                SmsManager.RESULT_ERROR_NULL_PDU -> "Null PDU"
                SmsManager.RESULT_ERROR_RADIO_OFF -> "Radio off"
                else -> "Unknown error"
            }
            eventSink?.success(status)
        }
    }

    private val smsDeliveredReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val status = when (resultCode) {
                RESULT_OK -> "SMS delivered"
                RESULT_CANCELED -> "SMS not delivered"
                else -> "Unknown delivery status"
            }
            eventSink?.success(status)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(smsSentReceiver)
        unregisterReceiver(smsDeliveredReceiver)
    }
    
}
