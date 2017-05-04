package com.zhuomogroup.ylyk.bean;

/**
 * Created by xyb on 2017/3/14.
 */

public class FileBean {

    /**
     * file_key : note/preload-c67bcb10-5977-4f1b-b23a-620b514f15ec-b0a5b1ea-5609-4e48-a436-400f23964615-1489476868.jpg
     * upload_token : bMIVqMz_fAZQ7dKNW1n_vr51Ym7toomVE4d89stq:Uf_vzLWiyRky8h5glyd9LXNSLPs=:eyJzY29wZSI6InlseWstaW1hZ2UiLCJkZWFkbGluZSI6MTQ4OTQ5ODQ2OH0=
     */

    private String file_key;
    private String upload_token;

    public String getFile_key() {
        return file_key;
    }

    public void setFile_key(String file_key) {
        this.file_key = file_key;
    }

    public String getUpload_token() {
        return upload_token;
    }

    public void setUpload_token(String upload_token) {
        this.upload_token = upload_token;
    }
}
