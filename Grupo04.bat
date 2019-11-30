tasm.exe /la /zi Final.asm > output1.txt
tasm.exe /la numbers.asm > output2.txt
tlink.exe /v Final.obj numbers.obj > output3.txt
Final.exe > output4.txt