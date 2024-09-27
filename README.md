## Using the PCRE2 C Library with Zig

```
Zig Version Used : 0.14.0-dev.1550+4fba7336a
```

I wanted to have regular expressions in my Zig program because reasons. Instead of using `regex.h`, I decided to go with [PCRE](https://www.pcre.org/current/doc/html/index.html). I started by using [the demo C code](https://www.pcre.org/current/doc/html/pcre2demo.html) on the PCRE website which you will find in the `/src` directory.

From there, I re-wrote the C code in Zig and discovered some quirks with how Zig interprets C macros. I go into [more detail here](https://sheran.sg/blog/building-and-using-pcre2-in-zig/).

### How to test

Clone the repo and then do `zig build run` to get results. You can change the pattern and the subject in the code. Note that you can only test UTF-8 strings at the moment.

### What good is this?

Consider this repo more as a reference than anything else. There is a lot more testing that needs to be done. It will be interesting to match a few of the go Regexp APIs.

Pull requests always welcome.
