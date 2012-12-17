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
    "path": "/Users/ogom/Pictures/syaraku_eye.jpg",
    "type": "file",
    "user": "ogom",
    "group": "staff",
    "mode": "0644",
    "size": 31165,
    "time": "2012-08-18 22:27:10",
    "md5": "40c3fd1d4579bca59f0aa37544cbdad7"
  },
]
```


## Licence

* MIT

