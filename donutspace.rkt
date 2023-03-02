#lang brag
begin: (ls* str8 ls*)+

@ls: /NL | /C /S

@str0: NUM | STR | KW | SYM | OPSYM
@str1: ppapp | apapp | list | str0
@str1a: cdapp | str1
@str2: ccapp | str1a
@str3: sapp | str2
@str4: iapp | str3
@str5: sdapp | str4
@str6: scapp | str5
@str7: ldapp | str6
@str8: lcapp | str7

/list: /OB str6? (/C /S str6)* /CB
/ppapp: str1 /OP str5? (/C /S str5)* /CP
@apapp: /OP str8 (ls str8)* /CP
cdapp:  str1a /DOT str1
/ccapp: str1 /SC str2
/sapp: str2 (/S /OP /CP | (/S str2)+)
/iapp: str2 (/S str2)* /NL />> (str8 ls)+ /<<
sdapp: str5 /S /DOT str4
/scapp: str2 (/S str2)* /SC /S str6
ldapp: str7 ls /DOT str6
/lcapp: str2 (/S str2)* /SC ls str7
