pipeline {
   environment {
      ID_DOCKER = "matt2022dockertp"
      IMAGE_NAME = "django"
      IMAGE_TAG = "latest"  
      DOCKERHUB_PASSWORD = credentials('dockerhubpassword')
  //could not translate host name "postgres" to address: Name or service not known
   }
  agent none
  stages {
    stage('Git clone provisoire via script') {
      agent any
      steps {
        script {
          sh 'sudo rm -rf FilRouge'
          sh 'docker rm -f django'
          sh 'git clone https://github.com/Relativ-IT/FilRouge.git'
        }
      }
    }
    stage('Build image - Front End Django only') {
      agent any
      steps {
        script {
          sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG ./FilRouge'
        }
      }
    }
    stage('Run container based on builded image (Django only-no DB)') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f $(docker ps -aq)
            docker run --name $IMAGE_NAME -d -p 8000:8000 $IMAGE_NAME:$IMAGE_TAG
            sleep 5
          '''
        }
      }
    }
    stage('Test Successfull: Django is active and NOK on Access- cause missing-Database') {
      agent any
      steps {
        script {
          sh '''
            docker logs django > test
            if grep -q Retry test; then echo "Successfully failed: no db response!"; else exit 1; fi;
        
          '''
        }
      }
    }
    stage('Test Fonctionnel: Database Postgres only') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f test
            docker run -tdi --name test -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres docker.io/postgres
            sleep 5
            docker exec test psql --username=postgres
            docker rm -f test
          '''
        }
      }
    }
    stage('Build & Run Appli Django complète = 2 running containers') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f $(docker ps -aq)
            cd ./FilRouge
            docker-compose up -d
            sleep 10
          '''
        }
      }
    }
     stage('Test image Appli Django complète (avec sa DB Postgres)') {
       agent any
       steps {
         script {
           sh '''
           curl http://localhost:8000 | grep -i "album"
        '''
         }
       }
     }
     stage('Clean Container de Django only') {
       agent any
       steps {
         script {
           sh '''
           docker stop filrouge_web_1
           docker rm filrouge_web_1
        '''
         }
       }
     }
      stage('Login and Push de Django Image (only) on Docker hub') {
        agent any
        steps {
          script {
            sh '''
                 echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
                 docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
        '''
         }
       }
     }
    // stage('Prepare ansible environment') {
    //   agent any
    //   environment {
    //     PRIVATE_KEY = credentials('private_keys_jenkins')
    //   }
    //   steps {
    //     sh ''
    //     '
    //     cp $PRIVATE_KEY id_rsa
    //     chmod 600 id_rsa
    //       ''
    //     '
    //   }
    // }
    // stage('Push image in staging and deploy it') {
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       cd $WORKSPACE / ansible && ansible - playbook playbooks / deploy_app.yml--private - key.. / id_rsa - e env = staging ''
    //       '
    //     }
    //   }
    // }
    // stage('Push image in production and deploy it') {
    //   when {
    //     expression {
    //       GIT_BRANCH == 'origin/master'
    //     }
    //   }
    //   agent any
    //   steps {
    //     script {
    //       sh ''
    //       '
    //       cd $WORKSPACE / ansible && ansible - playbook playbooks / deploy_app.yml--private - key.. / id_rsa - e env = prod ''
    //       '
    //     }
    //   }
    // }
    // stage('Remove temp files') {
    //   agent any
    //   steps {
    //     sh ''
    //     '
    //     rm - fr $WORKSPACE / ansible / id_rsa ''
    //     '
    //   }
    // }
  }
}