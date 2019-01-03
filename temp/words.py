f1 = open('words1.txt')
words1 = f1.read().split('\n')
del words1[-1]
f1.close()

f2 = open('words2.txt')
words2 = f2.read().split('\n')
del words2[-1]
f2.close()

output = []
for w in words1:
    if w in words2 and '-' not in w and len(w) > 2 and len(w) < 15:
        output.append(w)

output_str = '["' + '","'.join(output) + '"]'

print(output_str)
