Pipefish
========

Simple in-line encryption/decryption using a Blowfish cipher.

Usage
-----

```bash
$ echo "this is my text" | pipefish -k somekey
<encrypted output>
$ echo <encrypted output> | pipefish -k somekey -d
this is my text
```

Why would I use this?
---------------------

I specifically wrote this to be able to share semi-sensitive information easily with other folks using gist as the transport mechanism. So something like this:

```bash
$ echo "my secret stuff" | pipefish -k somekey | gist
$ curl <raw file url> | pipefish -k somekey -d
```
