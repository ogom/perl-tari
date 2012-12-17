tari
====

tari is archived from the file list of include.


## Installation

```
$ git clone https://github.com/ogom/perl-tari.git
$ cd perl-tari
$ chmod +x ./bin/tari.pl
$ sudo ln ./bin/tari.pl /usr/bin/tari
```


## Usage

### Execute archive

```
$ cat list.txt 
/tmp/001.txt
/tmp/002.txt
/tmp/003.txt
$ tari list.txt
$ tar tf list.tar 
./tmp/001.txt
./tmp/002.txt
./tmp/003.txt
```


### Change to directory

```
$ tari list.txt -c /
```


### Debug output JSON

```
$ tari list.txt -d
[
  {
    "path": "/tmp/001.txt",
    "type": "file",
    "user": "ogom",
    "group": "staff",
    "mode": "0644",
    "size": 3,
    "time": "2012-12-12 12:12:12",
    "md5": "dc5c7986daef50c1e02ab09b442ee34f"
  },
]
```


## Licence

* MIT

