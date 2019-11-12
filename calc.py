
import re
import math
import sys


text = '''\
1. R/V/I
2. U gain in dB
3. Low/High pass filter
4. NFB \
'''

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    
def parse(inputs):
    for key in inputs.keys():
       try:
           inputs[key] = parseUnit(inputs[key])
       except TypeError:
           raise TypeError
       except:
           pass   
    return inputs

def parseUnit (val):
    valTolist = [char for char in val]
    lastChar = valTolist[-1]
    if re.match(r"[pP]", lastChar):
        quant = 10**-12
    elif re.match(r"[nN]", lastChar):
        quant = 10**-9 
    elif re.match(r"[u]", lastChar):
        quant = 10**-6
    elif re.match(r"[m]", lastChar):
        quant = 10**-3
    elif re.match(r"[kK]", lastChar):
        quant = 10**3
    elif re.match(r"[M]", lastChar):
        quant = 10**6
    elif re.match(r"[G]", lastChar):
        quant = 10**9
    elif re.match(r"\d", lastChar):
        quant = 1
    else:
        print (bcolors.FAIL + "Unit %s not recognized" % lastChar + bcolors.ENDC)
        raise TypeError
    if not re.match(r"\d", lastChar):
        del valTolist[-1]
    vv = ''.join(valTolist)
    result = float(vv) * float(quant)
    return result
  

def current():
    inputs={}
    
    inputs['r'] = input('R: ')
    inputs['u']  = input('U: ')
    inputs['i']  = input('I: ')
    
    try:
       inputs = parse(inputs)
    except TypeError:
       return
           
    print()
    print('Results', "\n", '------')
    if not inputs['r']:
        r = inputs['u'] / inputs['i']
        print(bcolors.FAIL + "R=%g R" % r + bcolors.ENDC) 
    if not inputs['i']:
        i = inputs['u'] / inputs['r']
        print(bcolors.FAIL + "I=%g A" % i + bcolors.ENDC)
    if not inputs['u']:
        u = inputs['r'] * inputs['i']
        print(bcolors.FAIL + "U=%g V" % u + bcolors.ENDC)
    
def db():
    inputs={}
    
    inputs['v1'] = input('V1[V]: ')
    inputs['v2'] = input('V2[V]: ')
    inputs['g'] = input('Gain[dB]: ')
    
    try:
       inputs = parse(inputs)
    except TypeError:
       return
    
    if not inputs['g']:
       g = 20 * math.log10(inputs['v2']/inputs['v1'])
       print("Gain: {0:g}dB".format(round(g)))
    if not inputs['v1']:
       v1 = inputs['v2'] / 10 ** (inputs['g']/20) 
       print("V1: {0:g}V".format(round(v1)))   
    if not inputs['v2']:
       v2 = inputs['v1'] / 10 ** (inputs['g']/20) 
       print("V2: {0:g}V".format(round(v2)))
    
def lowhighPass():
    inputs = {}
      
    inputs['f'] = input('f[3dB]: ')
    inputs['r'] = input('R[ohm]: ')
    inputs['c'] = input('C[F]: ')
    
    try:
       inputs = parse(inputs)
    except TypeError:
       return
    
    if not inputs['f']:
        f = 1/(2 * 3.14 * inputs['r'] * inputs['c'] )
        print(bcolors.FAIL + "f=%g Hz" % f + bcolors.ENDC)
    if not inputs['c']:
        c = 1/(2 * 3.14 * inputs['f'] * inputs['r'] ) * 10**9
        print(bcolors.FAIL + "C=%gnF" % round(c, 2) + bcolors.ENDC)
    if not inputs['r']:
        r = 1/(2 * 3.14 * inputs['f'] * inputs['c'] )
        print(bcolors.FAIL + "R=%g R" % r) + bcolors.ENDC
        
def NFB():
   inputs = {}
   
   inputs['Ri'] = input('Ri[Ω]: ')
 #  inputs['Rf'] = input('Rf[Ω]: ')
 #  inputs['Go'] = input('Gain open loop[factor]: ')
 #  inputs['Gc'] = input('Gain closed loop[factor]: ')
   inputs['nfb'] = input('nfb[dB]: ')
   inputs['Go'] = input('Gain open loop[factor]: ')
   
   try:
      inputs = parse(inputs)
   except TypeError:
      return
   
#   if not inputs['Gc']:
#       inputs['Gc'] = inputs['Go'] / (1 + (inputs['Go'] * inputs['Ri']) / (inputs['Ri'] + inputs['Rf']))
#       print(bcolors.FAIL + "Gc=%g" % inputs['Gc'] + bcolors.ENDC)
#   if not inputs['Rf']:
   inputs['Gc'] = inputs['Go'] / 10 ** (inputs['nfb']/20) 
   inputs['Rf'] = inputs['Ri'] * ((inputs['Go'] * inputs['Gc']) + inputs['Go'] - inputs['Gc'])/(inputs['Go'] - inputs['Gc'])
   print(bcolors.FAIL + "R=%g Ω" % inputs['Rf'] + bcolors.ENDC)
   g = 20 * math.log10(inputs['Go']/inputs['Gc'])
   print (bcolors.FAIL + "nfb=%gdB" % g + bcolors.ENDC)
      
    
        
while True:
    print()
    print(text)
    z = input('?: ')
    z = int(z)
    if z == 1:
        current()
    elif z == 2:
        db()
    elif z == 3:
       lowhighPass()       
    elif z == 4:
       NFB()  
        
