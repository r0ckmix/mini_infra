import sys

try:
  with open("/etc/hosts", "a+") as file_object:
    file_object.seek(0)
    data = file_object.read(100)
    if len(data) > 0 :
      file_object.write("\n")
    file_object.write(sys.argv[1] + " " + sys.argv[2] + "." + sys.argv[3] + "\n" + sys.argv[4] + " " + sys.argv[5] + "." + sys.argv[6])
except:
  print('authorization error, please use user with admin authorization')