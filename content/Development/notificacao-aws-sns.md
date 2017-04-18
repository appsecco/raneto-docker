# Notificação com Aws ( SNS )

Sobre notificação usuando a AWS e seu serviço SNS, vamos separar em duas partes, uma para os PO's outra para os desenvolvedores.

### PO's

Sempre que falamos de desenvolvimento de notificação via AWS as principais informações que o PO precisa estar ciente são.

- Conta da AWS em qual o serviço vai ser operacionalizado.
- Conta da google em qual o app vai ser publicado, para que possamos ativar o firebase e cadastrar o app.
- Conta da Apple em qual o app vai ser publicado.

O desenvolvedor com essas informações em mãos consegue desenvolver a integração sem problemas.

### Desenvolvedores

Já para desenvolvedores a primeira coisa que temos que fazer é entender o processo de notificação.
 
###### Entendendo a AWS 

Dentro da aws temos 3 principais pontos:

**Application**

Application nada mais é com quais interfaces a AWS vai precisar conversar, iOS, Android(Firabase/GCM) ou outras opções.
Para cadastrar uma aplicação iOS é necessário gerar os certificados da apple para essa atividade sugiro essa biblioteca:
 - [Fast Line Pem](https://github.com/fastlane/fastlane/tree/master/pem)
 
Já para cadastrar uma aplicação android é necessario API key, esse dado é conseguido dentro do Firabase, cuidado aqui pois GCM é o antigo modo de gerenciar notificação da google.
A partir de agora só falamos de firabase. Um link para onde pegar essa informação é esse:
- [API key Firabase](http://docs.aws.amazon.com/pinpoint/latest/developerguide/mobile-push-android-cloud-messaging-project.html)


**Topics**

Um topic nada mas é que um grupo de endpoints, por padrão normalmente criamos sempre um topic a onde iremos associar todos os usuários da plataforma, assim facilita a notificação para todos os usuários.

**Endpoint**

Um enpoint nada mais é do que um device cadastrado na AWS.
Para cadastrar um device é necessário saber em qual application ele pertence (iOS, Android) , application que cadastramos anteriormente na plataforma.
Cadastrando um endpoint a AWS nós devolve um token, a partir de agora toda comunicação com a AWS é feita apenas por esse token.


###### Fluxo de Criação

Para entender um pouco melhor o fluxo de cadastro segue um exemplo de código.

```
    /**
     * Creates a new device to user and submit to Sns
     *
     * @param User $user
     * @param $platform
     * @param $dataDevice
     *
     * @return Device
    */
    public static function register(User $user, $platform, $dataDevice) {

        // recebemos o dataDevice do aplicativo Mobile e validamos se ele já não existe na nossa base 
        $device = Device::findOne(['data_device' => $dataDevice, 'fk_user' => $user->pk_user]);

        if (!empty($device) && !empty($device->pk_device)) {
            return $device;
        }

        // Setamos as configurações da aws para conexão
        $sns = new Sns([
            'key' => Key::findOne(['name' => 'aws-sns-key'])->value,
            'secret' => Key::findOne(['name' => 'aws-sns-secret'])->value,
           'region' => Key::findOne(['name' => 'aws-sns-region'])->value
           ]
        );

        $model = new Device();

        $model->fk_user = $user->pk_user;
        $model->data_device = $dataDevice;
        $model->type = $platform;

        // baseado na plataforma que é o device definimos nossa Application e o ID dela.
        if ($platform == Device::IOS) {
            $application = "arn:aws:sns:sa-east-1:627040845552:app/APNS/ProjetcLiveProd";
        } else {
            $application = "arn:aws:sns:sa-east-1:627040845552:app/GCM/ProjectLiveAndroid";
        }

        // Criamos nosso endPoint junto a aws
        $endPoint = $sns->createPlatformEndpoint(array(
            'PlatformApplicationArn' => $application,
            'Token' => $dataDevice,
            'CustomUserData' => 'nome_do_projeto')
        );

        if (isset($endPoint['EndpointArn'])) {
            // salvamos o endpoint de retorno para nossa base
            $model->token = $endPoint['EndpointArn'];

            // Fazemos o subscribe no Topic que criamos para nossos usuários.
            $sns->subscribe(array(
                'TopicArn' => "arn:aws:sns:sa-east-1:627040845552:project-live",
                'Protocol' => 'application',
                'Endpoint' => $endPoint['EndpointArn'],
            ));

            $model->save();

        } else {
            return null;
        }

        return $model;

    }
 ```

###### Enviando Notificação

Com o cadastro realizado a unico passo falta é o envio de notificação.

```
 /**
    * Send a notification to a endpoint
    *
    * @param $text
    * @param $subject
    * @param $target
    *
    * @return Device
 */
 public function sendNotification($text,$subject,$target = null){
        $sns = new Sns([
             'key' => Key::findOne(['name' => 'aws-sns-key'])->value,
             'secret' => Key::findOne(['name' => 'aws-sns-secret'])->value,
            'region' => Key::findOne(['name' => 'aws-sns-region'])->value
            ]
        );
        try{
            return $sns->publish(
                array(
                    'Subject' => $subject,
                    'Message' => $text,
                    //Vale lembrar que aqui pode ser tanto o endpoint do usuário devolvido pela AWS ou o id do Topico para notificar para todos do grupo
                    'TargetArn' => $target
                )
            );
        }catch (\Exception $e){ }
 }
```

