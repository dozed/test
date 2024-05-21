

# Running a local SPARQL server with the DBLP dataset by using qlever

We provide a step-by-step tutorial on how to run your own SPARQL server on a linux machine. Therefore we assume that you are the ```root```-user of the system.


## System requirements

In order to host your own version of the dataset using qlever, we recommend:

- 16 GB of free RAM
- xx GB of free Disk space (Tested with 40, failed, retry with 45)

This is sufficient to build a qlever index and run the qlever server afterwards.


## Installing dependencies

In order to run your own SPARQL enpoint, you need the following software:

- python3
- pip
- curl
- docker

On Ubuntu, you can install these by running the following command:

```
apt install python3 python3-pip docker.io curl
```


## Installing the qlever control script

We next need to install the qlever control script by installing the package ```qlever``` via pip:

```
pip install qlever
```


## Using the qlever control script to run a SPARQL endpoint with the DBLP dataset

In order to run an endpoint, we first need to create a directory that should contain the data for the endpoint and ```cd``` into this directory. In this example we use ```~/sparql-dblp```.

```
mkdir ~/sparql-dblp
cd ~/sparql-dblp
```

Then we need to create a configuration file for qlever. Qlever comes with an example file for the DBLP dataset preconfigured, so we can simply use that by running:

```
qlever setup-config dblp
```

This creates a ```Qleverfile``` in the current directory, which has all the information on how to get the dataset and build the index for the dataset and so on. Next we need to fetch the data and build the index by running the following commands:

```
qlever get-data
qlever index
```

This may take a while. After the index is prepared, we finally need to start the qlever server and the UI by running the following commands:

```
qlever start
qlever ui
```

Once those services are up, you can access the query UI at [http://localhost:7000](http://localhost:7000) and use the dataset.

