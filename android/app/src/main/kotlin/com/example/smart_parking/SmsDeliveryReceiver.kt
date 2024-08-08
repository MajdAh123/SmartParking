package com.example.smart_parking

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SmsDeliveryReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val statusIntent = Intent("SMS_DELIVERY_STATUS")
        when (resultCode) {
            android.app.Activity.RESULT_OK -> {
                statusIntent.putExtra("status", "SMS delivered")
            }
            android.telephony.SmsManager.RESULT_ERROR_GENERIC_FAILURE -> {
                statusIntent.putExtra("status", "Generic failure")
            }
            android.telephony.SmsManager.RESULT_ERROR_NO_SERVICE -> {
                statusIntent.putExtra("status", "No service")
            }
            android.telephony.SmsManager.RESULT_ERROR_NULL_PDU -> {
                statusIntent.putExtra("status", "Null PDU")
            }
            android.telephony.SmsManager.RESULT_ERROR_RADIO_OFF -> {
                statusIntent.putExtra("status", "Radio off")
            }
        }
        context?.sendBroadcast(statusIntent)
    }

    
}
