# Setup Up Web View - ANDROID

#### Criando a web view na main activity

1. Acesse o arquivo activity_main.xml.
![](https://imgur.com/dP1toMs.png)

2. Certifique-se que esta no modo Design, e no canto superior direito busque por WebView
![](https://imgur.com/pELoCDy.png)

3. Arraste para o device, e redimensione para que ocupe 100% da tela.
![](https://imgur.com/RodQPjn.png)

4. Va para sua Main Activity
![](https://i.imgur.com/xgYIPw5.png)

4. Sobescreva o seu método OnCreate
  ```
      protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            
            //Remove o título padrao do android
            this.requestWindowFeature(Window.FEATURE_NO_TITLE);
            
            setContentView(R.layout.activity_main);
            
            // Busca a WebView da MainActivity
            WebView mWebView = (WebView)findViewById(R.id.webView);
            
            // Seta algumas permissoes
            mWebView.getSettings().setJavaScriptEnabled(true); // Permissao para acessar JS
            mWebView.getSettings().setAllowFileAccess(true); // Permissao para acessar arquivo
            mWebView.getSettings().setDomStorageEnabled(true); // Permissao para acessar LocalStorage
            mWebView.getSettings().setDatabaseEnabled(true); // ...
            mWebView.getSettings().setSaveFormData(false); // ...
            mWebView.getSettings().setUseWideViewPort(true); // ...
            // Link para sua aplicacao
            mWebView.loadUrl("http://letsrock.hero99.com.br/clientes/adrenalyze-app/"); // 
            
            // Seta como navegador a abrir sua applicacao o Google Chrome
            mWebView.setWebChromeClient(new WebChromeClient() {
                // Aqui vem a comunicacao da WebView com o Android
            })
    }
```

6. Para finalizar, segue uma configuração padrão para o seu manifest...
Essa configuracao serve para resolver problemas como por exemplo
* Teclado aberto toda vez que applicacao é iniciada `android:configChanges="keyboardHidden"`
* Titulo do tema padrao do android `android:theme="@android:style/Theme.NoTitleBar"`

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.adrenalyze.adrenalyzeandroid"
    android:theme="@android:style/Theme.NoTitleBar">

<!-- Algumas permissoes do smarthphone -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<uses-feature
    android:name="android.hardware.camera"
    android:required="true" />

<application
    android:allowBackup="true"
    android:icon="@mipmap/ic_launcher"
    android:label="@string/app_name"
    android:supportsRtl="true"
    android:theme="@style/AppTheme"
    android:windowSoftInputMode="stateAlwaysHidden"
    >

    <activity
        android:name=".MainActivity"
        android:configChanges="keyboardHidden|orientation|screenSize"
        android:launchMode="singleTask"
        android:screenOrientation="portrait"
        android:windowSoftInputMode="stateAlwaysHidden"
        >
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />

            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>
    </activity>

</application>

</manifest>
```
#### Pronto, agora é só rodar só seu APP
