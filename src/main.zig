const std = @import("std");
const re = @cImport({
    @cDefine("PCRE2_CODE_UNIT_WIDTH", "8");
    @cInclude("pcre2.h");
});

const PCRE2_ZERO_TERMINATED = ~@as(re.PCRE2_SIZE, 0);

pub fn pcre(pat: [*]const u8, sub: []const u8 ) void{
    const pattern : [*]const u8 = pat;
    var errornumber : i32 = undefined;
    var erroroffset : usize = undefined;
    const regeex = re.pcre2_compile_8(
        pattern,
        PCRE2_ZERO_TERMINATED,
        0,
        &errornumber,
        &erroroffset,
        null);

    if (regeex == null){
        var errormessage : [256]u8 = undefined;
        const msgLen : c_int = re.pcre2_get_error_message_8(errornumber, &errormessage, errormessage.len);
        std.debug.print("Error compiling: {s}\n",.{errormessage[0..@intCast(msgLen)]});
        return;
    }

    const subject : []const u8  = sub;
    const subject_length : usize = subject.len;

    const match_data = re.pcre2_match_data_create_from_pattern_8(regeex, null);
    const rc = re.pcre2_match_8(regeex, &subject[0], subject_length, 0, 0, match_data, null);

    if (rc < 0) {
        switch (rc) {
            re.PCRE2_ERROR_NOMATCH => {
                std.debug.print("No match found\n",.{});
            },
            else => {
                std.debug.print("Matching error: {}\n",.{rc});
            }
        }
        re.pcre2_match_data_free_8(match_data);
        re.pcre2_code_free_8(regeex);
    }

    const ovector = re.pcre2_get_ovector_pointer_8(match_data);
    if (rc == 1){
        std.debug.print("Match found at offset: {}\n",.{ovector.*});
    } else if (rc > 1){
        for(0..@intCast(rc))|i|{
            std.debug.print("{}: {s}\n",.{i, subject[ovector[2 * i]..ovector[2 * i + 1]]});
        }
    }

    re.pcre2_match_data_free_8(match_data);
    re.pcre2_code_free_8(regeex);
}


pub fn main() !void {
    pcre(
        "base",                                         // pattern
        "all your codebase are belong to us.");         // subject
}
