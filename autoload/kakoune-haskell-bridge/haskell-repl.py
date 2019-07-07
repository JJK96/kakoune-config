import pexpect
import pexpect.replwrap
import sys

input = sys.argv[1]
output = sys.argv[2]
repl_cmd = sys.argv[3]
prompt_sign = sys.argv[4]
set_prompt = sys.argv[5]

p = pexpect.replwrap.REPLWrapper(repl_cmd, prompt_sign, set_prompt)
if len(sys.argv) > 6:
    extra_init_cmd = sys.argv[6]
    p.run_command(extra_init_cmd)

while True:
    with open(input, 'r') as f:
        c = f.read()
        try:
            out = open(output, 'w')
            out.write(p.run_command(c).replace('\r', ''))
        finally:
            out.close()
