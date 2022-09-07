%NProcShared=28
%mem=200GB
%Chk=job_1_ethyl_3_methylimidazol_3_ium.chk
#p B3LYP/6-311G** em=GD3BJ Opt freq int=fine

1_ethyl_3_methylimidazol_3_ium

1  1
C      2.735249    0.373510    0.441738
C      1.851584   -0.734785   -0.095895
N      0.446829   -0.505046    0.248811
C     -0.208412   -0.990272    1.369834
C     -1.496460   -0.540682    1.298641
N     -1.595398    0.206679    0.136409
C     -0.409162    0.218797   -0.489058
C     -2.796255    0.880034   -0.340692
H      2.662461    0.435146    1.532245
H      2.434548    1.343559    0.033142
H      3.780885    0.194734    0.174471
H      1.931693   -0.792380   -1.186937
H      2.159548   -1.703574    0.312241
H      0.332882   -1.595211    2.076937
H     -2.363167   -0.654515    1.926994
H     -0.180769    0.722620   -1.421478
H     -3.588451    0.140180   -0.482959
H     -2.590678    1.378768   -1.291520
H     -3.106929    1.622440    0.399222

--link1--
%oldchk=./job_1_ethyl_3_methylimidazol_3_ium.chk
%chk=job_1_ethyl_3_methylimidazol_3_ium_gas.chk
# B3LYP/def2TZVP em=GD3BJ geom=allcheck


--link1--
%oldchk=./job_1_ethyl_3_methylimidazol_3_ium.chk
%chk=job_1_ethyl_3_methylimidazol_3_ium_solv.chk
# B3LYP/def2TZVP em=GD3BJ scrf=solvent geom=allcheck

