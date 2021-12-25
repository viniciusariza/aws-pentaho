#Passo 1 - Configurações da instância EC2 e instalação dos softwares necessários
cd ~/.ssh #Acessar diretório .ssh
ssh-keygen #Gerar chave ssh
sudo adduser pentaho #Adicionar usuário
sudo passwd pentaho #Atribuir senha ao usuário criado
sudo nano /etc/sudoers #Atribuir permissões ao usuário sudoers
pentaho	ALL=(ALL:ALL) ALL #Atribuir permissões ao usuário sudoers
sudo mkdir /home/pentaho/.ssh #Criar diretório .ssh
sudo cp ~/.ssh/authorized_keys /home/pentaho/.ssh/authorized_keys #Copiar keygen 
sudo chown pentaho:pentaho /home/pentaho/.ssh/authorized_keys #Mudar owner
sudo chmod 600 /home/pentaho/.ssh/authorized_keys # Atribuir privilégios 

#Passo 2 - Instalar pentaho (padrão)

#Passo 3 - Instalar JDK (padrão)

#Passo 4 - Testar pentaho.
#Após instalar JDK e editar as variáveis de ambiente, tentar executar o arquivo spoon no diretório do pentaho
spoon.sh

#Passo 5 - Fazer download do driver JDBC do banco de dados e mover para .../data-integrator/lib

#Passo 6 - Criar credenciais de acesso ao AWS
sudo mkdir /home/pentaho/.aws #Criar diretório .aws
curl -O https://bootstrap.pypa.io/get-pip.py #Instalar pip e editar variáveis de ambiente
python get-pip.py --user
export PATH=~/.local/bin:$PATH
source ~/.bash_profile
#Criar AWS Key no AWS
pip install awscli #Instalar AWS Cli
aws configure #Configurar com os dados da AWS Key

#Passo 7 - Criar transformação no pentaho com no mínimo 2 steps, utilizando repositório remoto com o cliente na máquina local
#Step 1: Table input (com as credenciais do RDS)
#Step 2: S3 output (Necessário ter executado o passo anterior)
DIRETÓRIO_PENTAHO/./kitchen.sh /rep:"REPOSITÓRIO" /job:"Job" #Criar arquivo com extenção .sh

#Passo 8 - Indicar repositório do pentaho editando arquivo repositores.xml no diretório .kettle, com a estrutura a seguir.
<?xml version="1.0" encoding="UTF-8"?>
<repositories>
  <repository>    <id>KettleFileRepository</id>
    <name>NOMEREPOSITÓRIO</name>
    <description/>
    <is_default>false</is_default>
    <base_directory>DIRETÓRIO</base_directory>
    <read_only>N</read_only>
    <hides_hidden_files>N</hides_hidden_files>
  </repository>  </repositories>

#Passo 9 - Editar cron para executar na janela requerida (padrão)
crontab -e
* * * * * CAMINHO_ARQUIVO_kitchen.sh

#Passo 10 - Criar função Lambda para inicializar e parar instâncias EC2
#Start instância
import boto3
region = 'us-east-2'
instances = ['i-0319c1058971...']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
	

#Stop instância
import boto3
region = 'us-east-2'
instances = ['i-0319c1058971...']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
	
#Passo 11 - Criar janela de atualização com o EventBridge, executando função Lambda


#Passo 12 - Executar crawler no Glue e acessar com o Athena, se atentando para a configuração correta das roles e policies (padrão)

#Passo 13 - Consumir os dados em ferramenta de Data Viz através de conector nativo ou JDBC
jdbc:awsathena://athena.us-east-2.amazonaws.com:443;UID=[MY_AWS_ACCESS_KEY];PWD=[MY_AWS_SECRET_KEY];S3OutputLocation=s3://[S3_OUTPUT_BUCKET];