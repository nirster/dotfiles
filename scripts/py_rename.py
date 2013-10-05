#!/usr/bin/python2
# -*- coding: UTF-8 -*-

import os,sys,json,subprocess,re

rootdir = sys.argv[1]

def translit(cyr_str):
    capital_letters = { u'А': u'A', u'Б': u'B', u'В': u'V', u'Г': u'G', u'Д': u'D', u'Е': u'E', u'Ё': u'E', u'Ж': u'j', u'З': u'Z', u'И': u'I', u'Й': u'Y', u' К': u'K', u'Л': u'L', u'М': u'M', u'Н': u'N', u'О': u'O', u'П': u'P', u'Р': u'R ', u'С': u'S', u'Т': u'T', u'У': u'U', u'Ф': u'F', u'Х': u'H', u'Ц': u'Ts', u'Ч ': u'Ch', u'Ш': u'Sh', u'Щ': u'Sch', u'Ъ': u'y', u'Ы': u'Y', u'Ь': u'i', u'Э': u'E', u'Ю': u'Yu', u'Я': u'Ya' }

    lower_case_letters = { u'а': u'a', u'б': u'b', u'в': u'v', u'г': u'g', u'д': u'd', u'е': u'e', u'ё': u'e', u'ж': u'j', u'з': u'z', u'и': u'i', u'й': u'y', u'к': u'k', u'л': u'l', u'м': u'm', u'н': u'n', u'о': u'o', u'п': u'p', u'р': u'r', u'с': u's', u'т': u't', u'у': u'u', u'ф': u'f', u'х': u'h', u'ц': u'ts', u'ч': u'ch', u'ш': u'sh', u'щ': u'sch', u'ъ': u'y', u'ы': u'y', u'ь': u'i', u'э': u'e', u'ю': u'yu', u'я': u'ya' }

    translit_string = ""

    for index, char in enumerate(cyr_str):
        if char in lower_case_letters.keys():
            char = lower_case_letters[char]
        elif char in capital_letters.keys():
            char = capital_letters[char]
            if len(cyr_str) > index+1:
                if cyr_str[index+1] not in lower_case_letters.keys():
                    char = char.upper()
            else:
                char = char.upper()
        translit_string += char

    return translit_string

def get_finger_print(audio_file):
    results = subprocess.Popen(['/usr/bin/echoprint-codegen',audio_file,'10','40'],stdout=subprocess.PIPE)
    r=results.communicate()[0]
    data=json.loads(r)
    if data[0].has_key('error'):
        print data[0]['error']
        song_title=("failed")
        song_artist=("failed")
    else:
        song_title=data[0]['metadata']['title']
        song_artist=data[0]['metadata']['artist']

    if isinstance(song_artist,unicode):
        song_artist =  translit(data[0]['metadata']['artist'])
    if isinstance(song_title,unicode):
        song_title = translit(data[0]['metadata']['title'])

    return song_title,song_artist

def clean_up_names(string):
    string=(re.sub("['\"]", "", string))
    string=(re.sub("[^\w]+", "_", string))
    string=(re.sub("[_]+", "_", string))
    if string.endswith('_'):
        string=string[:-1]
    if string.startswith('_'):
        string=string[1:]
    string=string.title()

    return string

for path, subdirs, files in os.walk(rootdir):
    for name in files:
        print os.path.join(path,name)
        (s_title,s_artist)=get_finger_print(os.path.join(path, name))
        s_title_c=clean_up_names(s_title)
        s_artist_c=clean_up_names(s_artist)
        if (s_title_c != 'Failed') and (s_artist_c != 'Failed'):
            ext=os.path.splitext(name)[1].lower()
            filename="%s-%s%s" % (s_artist_c,s_title_c,ext)
            src=os.path.join(path,name)
            dst=os.path.join(path,filename)
            if str(dst) != src:
                print ("Renaming from " + src + " to " + str(dst))
                os.rename(src,dst)

