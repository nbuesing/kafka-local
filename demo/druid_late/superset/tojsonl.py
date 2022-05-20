import pandas
df = pandas.read_csv("x.csv", header=None)

file_to_write = ""
for index in df.index:
    df.loc[index].to_json("row{}.json".format(index))
    with open("row{}.json".format(index)) as file_handle:
        file_content = file_handle.read()
        file_to_write += file_content + "\n"
        
with open("x.jsonl","w") as file_handle:
    file_handle.write(file_to_write)
