%NProcShared=28
%mem=200GB
%Chk=job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.chk
#p B3LYP/6-311G** em=GD3BJ Opt freq int=fine

1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate

-1  1
C     -2.667547    0.248836    0.013024
F     -2.817370    0.758947    1.268958
F     -3.558323    0.900615   -0.783789
F     -3.073138   -1.050842    0.078313
S     -0.946386    0.401185   -0.582832
N     -0.153201   -0.479800    0.601226
S      1.370921   -1.095759    0.290036
O      1.948644   -1.388277    1.595850
O      1.220241   -2.194427   -0.649943
C      2.290515    0.311051   -0.477378
F      1.826308    0.642097   -1.710562
F      3.615701    0.026554   -0.626175
F      2.221399    1.432326    0.292672
O     -0.484193    1.772383   -0.453356
O     -0.793570   -0.284889   -1.851629

--link1--
%oldchk=./job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.chk
%chk=job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_gas.chk
# B3LYP/def2TZVP em=GD3BJ geom=allcheck


--link1--
%oldchk=./job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.chk
%chk=job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_solv.chk
# B3LYP/def2TZVP em=GD3BJ scrf=solvent geom=allcheck

