
"""

.Rmd file statistics

10am-5pm day. 30 minutes intro. 1 hour break. 5.5 hours teaching.

               blocks  lines   per block
start          18      40      2.2
matrices       25      61      2.4
<lunch>
data frames    28      62      2.2
for loops      11      57      5.2  <- !
ggplot         15      34      2.3

               97      254

           18/hour     46/hour

Programming will involve larger blocks than
interactive work.

For topics we just want to give people a taste of
introduce knitr and Rmarkdown,
then have a different mode where we work
much faster from an existing file.

"""

import sys

def check_complexity(filename):
    print filename

    with open(filename,"rU") as f:
        in_code = False
        code_blocks = 0
        code_lines = 0
        for line in f:
            if line.startswith("```"):
                in_code = not in_code
                if in_code:
                    code_blocks = code_blocks + 1
                continue
            if in_code:
                if line.strip():
                    code_lines = code_lines + 1
        assert not in_code

    print code_blocks, "blocks", code_lines, "lines"
    print

if __name__ == "__main__":
    for filename in sys.argv[1:]:
        check_complexity(filename)
