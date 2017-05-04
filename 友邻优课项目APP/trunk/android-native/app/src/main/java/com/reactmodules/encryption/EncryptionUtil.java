package com.reactmodules.encryption;

import android.util.Base64;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

/**
 * Created by xyb on 2017/2/13.
 */

public class EncryptionUtil {


    private static final String ENCRYPTION_UTF8 = "UTF-8";
    private static final String ENCRYPTION_MAC_SHA1 = "HmacSHA1";
    private static final String ENCRYPTION_MAC_MD5 = "HmacMD5";
    private static final String ENCRYPTION_MD5 = "MD5";
    private static final String ENCRYPTION_SHA1 = "SHA-1";

    /**
     * ENCRYPTION_MD5
     * 加密方法
     *
     * @param encryptionMsg 加密内容
     * @return
     */

    public static String MD5(String encryptionMsg) {
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        try {
            byte[] btInput = encryptionMsg.getBytes();
            // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance(ENCRYPTION_MD5);
            // 使用指定的字节更新摘要
            mdInst.update(btInput);
            // 获得密文
            byte[] md = mdInst.digest();
            // 把密文转换成十六进制的字符串形式
            int j = md.length;
            char str[] = new char[j * 2];
            int k = 0;
            for (byte byte0 : md) {
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    /**
     * 使用 HMAC-ENCRYPTION_SHA1 签名方法对对encryptText进行签名
     *
     * @param encryptText 被签名的字符串
     * @param encryptKey  密钥
     * @return
     * @throws Exception
     */
    public static String HmacSHA1(String encryptText, String encryptKey) throws Exception {
        byte[] data = encryptKey.getBytes(ENCRYPTION_UTF8);
        //根据给定的字节数组构造一个密钥,第二参数指定一个密钥算法的名称
        SecretKey secretKey = new SecretKeySpec(data, ENCRYPTION_MAC_SHA1);
        //生成一个指定 Mac 算法 的 Mac 对象
        Mac mac = Mac.getInstance(ENCRYPTION_MAC_SHA1);
        //用给定密钥初始化 Mac 对象
        mac.init(secretKey);

        byte[] text = encryptText.getBytes(ENCRYPTION_UTF8);
        //完成 Mac 操作
        byte[] rawHmac = mac.doFinal(text);
        StringBuilder sb = new StringBuilder();
        for (byte b : rawHmac) {
            sb.append(byteToHexString(b));
        }
        return sb.toString();
    }

    private static String byteToHexString(byte ib) {
        char[] Digit = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
        };
        char[] ob = new char[2];
        ob[0] = Digit[(ib >>> 4) & 0X0f];
        ob[1] = Digit[ib & 0X0F];
        return new String(ob);
    }


    /**
     * 使用 HMAC-ENCRYPTION_SHA1 签名方法对对encryptText进行签名
     *
     * @param encryptText 被签名的字符串
     * @param encryptKey  密钥
     * @return
     * @throws Exception
     */
    public static String HmacMD5(String encryptText, String encryptKey) throws Exception {
        byte[] data = encryptKey.getBytes(ENCRYPTION_UTF8);
        //根据给定的字节数组构造一个密钥,第二参数指定一个密钥算法的名称
        SecretKey secretKey = new SecretKeySpec(data, ENCRYPTION_MAC_MD5);
        //生成一个指定 Mac 算法 的 Mac 对象
        Mac mac = Mac.getInstance(ENCRYPTION_MAC_MD5);
        //用给定密钥初始化 Mac 对象
        mac.init(secretKey);

        byte[] text = encryptText.getBytes(ENCRYPTION_UTF8);
        //完成 Mac 操作

        //完成 Mac 操作
        byte[] rawHmac = mac.doFinal(text);
        StringBuilder sb = new StringBuilder();
        for (byte b : rawHmac) {
            sb.append(byteToHexString(b));
        }
        return sb.toString();
    }

    /**
     * ENCRYPTION_SHA1
     *
     * @param val
     * @return
     * @throws NoSuchAlgorithmException
     */
    public static String SHA1(String val) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest md5 = MessageDigest.getInstance(ENCRYPTION_SHA1);
        md5.update(val.getBytes());
        StringBuffer buf = new StringBuffer();
        byte[] bits = md5.digest();
        for (int i = 0; i < bits.length; i++) {
            int a = bits[i];
            if (a < 0) a += 256;
            if (a < 16) buf.append("0");
            buf.append(Integer.toHexString(a));
        }
        return buf.toString();
    }


    /**
     * base64
     *
     * @param val
     * @return
     */
    public static String BASE64(String val) {
        String encodeToString = Base64.encodeToString(val.getBytes(), Base64.DEFAULT);
        encodeToString = encodeToString.replaceAll("\r|\n", "");
        return encodeToString;
    }


}
