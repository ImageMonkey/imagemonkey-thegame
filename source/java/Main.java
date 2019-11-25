package io.imagemonkey.thegame;

import android.content.Context;
import android.os.Vibrator;
import android.app.Activity;
import android.os.Bundle;
import io.imagemonkey.thegame.R;
import android.util.Log;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;

//imports for android keystore
import javax.crypto.Cipher;
import android.util.Base64;
import android.content.Context;
import javax.crypto.spec.SecretKeySpec;
import android.security.keystore.KeyProtection;
import java.util.ArrayList;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import javax.crypto.CipherInputStream;
import java.security.KeyStore;
import javax.crypto.CipherOutputStream;
import java.security.Key;
import java.security.KeyPairGenerator;
import android.security.keystore.KeyProperties;
import android.security.KeyPairGeneratorSpec;
import javax.security.auth.x500.X500Principal;
import java.math.BigInteger;
import java.util.Calendar;
import java.security.SecureRandom;
import android.os.Build;

//imports for android keystore (Android >= M)
import android.security.keystore.KeyGenParameterSpec;
import javax.crypto.KeyGenerator;
import java.security.KeyPair;
import java.security.PublicKey;

public class Main extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static final String TAG = "MainActivity";
    private KeyStore m_keyStore;


    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume()
    {
        super.onResume();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onPause()
    {
        super.onPause();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }


    public static Main m_istance;
    public Main()
    {
        m_istance = this;
    }
}
