tari
====

tari is archived from the file list of include.


## Installation

```
$ cd perl-tari
$ chmod +x ./bin/tari.pl 
$ sudo ln ./bin/tari.pl /usr/bin/tari
```


## Usage

```
$ tari list.txt
[
  {
    "path": "/tmp/001.txt",
    "type": "file",
    "user": "ogom",
    "group": "staff",
    "mode": "0644",
    "size": 3,
    "time": "2012-12-12 01:01:22",
    "md5": "dc5c7986daef50c1e02ab09b442ee34f"
  },
  {
    "path": "/tmp/002.txt",
    "type": "file",
    "user": "ogom",
    "group": "staff",
    "mode": "0644",
    "size": 3,
    "time": "2012-12-12 01:01:33",
    "md5": "93dd4de5cddba2c733c65f233097f05a"
  },
  {
    "path": "/tmp/003.txt",
    "type": "file",
    "user": "ogom",
    "group": "staff",
    "mode": "0644",
    "size": 3,
    "time": "2012-12-12 01:01:44",
    "md5": "e88a49bccde359f0cabb40db83ba6080"
  },
]


### Include list

```
$ cat list.txt 
/tmp/001.txt
/tmp/002.txt
/tmp/003.txt
```


### List archive contents

```
$ tar tf list.tar 
./tmp/001.txt
./tmp/002.txt
./tmp/003.txt
```


## Licence

* MIT

