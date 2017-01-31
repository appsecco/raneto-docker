# Knowledgebase in a Docker container using Raneto

[Raneto](http://raneto.com) is an open source Knowledgebase platform that uses static Markdown files to power your Knowledgebase.

This docker container is to setup Knowledgebase available in a container to start your centralised documentation in seconds.

More details about the project can be [found here](http://docs.raneto.com/)

- Here is the blog post to know more about [Markdown based Knowledgebase]()

### How to use docker container

The simple and quick way to use this container is as follows.

**Software required to use docker container**

- Docker (Tested version 1.13.0)

**Steps to use container**

- Pull the [Raneto](https://hub.docker.com/r/appsecco/raneto) image from the docker hub

```
docker pull appsecco/raneto
```

- Clone the repostiory for sample configuration and content

```
git clone https://github.com/appsecco/raneto-docker.git

cd raneto-docker
```

- Make changes for configuration if required in `config/config.default.js`

- Then you are ready to run the Knowledgebase

```
docker run -v `pwd`/content/:/data/content/ -v `pwd`/config/config.default.js:/opt/raneto/example/config.default.js -p 3000:3000 -d appsecco/raneto
```

- Then navigate to [http://localhost:3000](http://localhost:3000)

- If you want to add more content to the Knowledgebase. Just add your directories (or) markdown files to the `content` folder in host system. It will update automatically


---


Please feel free to make a pull request or tweet to me [@madhuakula](https://twitter.com/madhuakula) for improvements and suggestions