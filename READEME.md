## Using the PCRE2 C Library with Zig

```
Zig Version Used : 0.14.0-dev.1550+4fba7336a
```

I wanted to have regular expressions in my Zig program because reasons. Instead of using `regex.h`, I decided to go with [PCRE](https://www.pcre.org/current/doc/html/index.html). I started by using [the demo C code](https://www.pcre.org/current/doc/html/pcre2demo.html) on the PCRE website which you will find in the `/src` directory.

From there, I re-wrote the C code in Zig and discovered some quirks with how Zig interprets C macros. I go into [more detail here](https://sheran.sg/blog/building-and-using-pcre2-in-zig/).

### How to test

Clone the repo and then use `pcre([]const u8: pattern, []const u8 subject)`. Where `pattern` is your needle and `subject` is your haystack.

Then do `zig build run` to get results. Noted that you can only test UTF-8 strings at the moment.

### What good is this?

Consider this repo more as a reference than anything else. There is a lot more testing that needs to be done. Of particular note will be:

* How to integrate PCRE2 into Zig using the `build.zig` file. (PCRE2 already has a build.zig in its repo!)
* How to use PCRE2 from within Zig. I find that writing the C first and then translating works best for me.

Pull requests always welcome.
