#define PCRE2_CODE_UNIT_WIDTH 8
#include "../../pcre2/install/include/pcre2.h"
#include <stdio.h>
#include <string.h>

int main() {
  uint8_t *pattern = (uint8_t *)"\\s(b.*)";
  int errornumber;
  size_t erroroffset;
  pcre2_code_8 *re = pcre2_compile(
      pattern,
      PCRE2_ZERO_TERMINATED,
      0,
      &errornumber,
      &erroroffset,
      NULL);
  if (re == NULL) {
    PCRE2_UCHAR buffer[256];
    pcre2_get_error_message(errornumber, buffer, sizeof(buffer));
    printf("PCRE2 compilation failed at offset %d: %s\n", (int)erroroffset,
           buffer);
    return 1;
  }
  uint8_t *subject = (uint8_t *)"this is bollocks!";
  size_t subject_length = (size_t)strlen((char *)subject);
  pcre2_match_data *match_data = pcre2_match_data_create_from_pattern(re, NULL);
  int rc = pcre2_match(re, subject,
                       subject_length,
                       0,
                       0,
                       match_data,
                       NULL);
  if (rc < 0) {
    switch (rc) {
    case PCRE2_ERROR_NOMATCH:
      printf("No match\n");
      break;
    default:
      printf("Matching error %d\n", rc);
      break;
    }
    pcre2_match_data_free(match_data);
    pcre2_code_free(re);
    return 1;
  }
  size_t *ovector = pcre2_get_ovector_pointer(match_data);
  if (rc == 1) {
    printf("Match succeeded at offset %d\n", (int)ovector[0]);
  } else if (rc > 1) {
    for (int i = 0; i < rc; i++) {
      PCRE2_SPTR substring_start = subject + ovector[2 * i];
      PCRE2_SIZE substring_length = ovector[2 * i + 1] - ovector[2 * i];
      printf("%2d: %.*s\n", i, (int)substring_length, (char *)substring_start);
    }
  }
  pcre2_match_data_free(match_data);
  pcre2_code_free(re);
}
