clear
import delimited "/Users/tgallen/Dropbox/Econ_641/HwkSol/New Homework 4/Data.csv"
rename v1 c1
rename v2 c2
rename v3 L1
rename v4 L2
rename v5 w1
rename v6 w2
rename v7 r
rename v8 nu

gmm (((nu+r*nu+w1+r*w1+w2)/((1+r)*(1+{beta})*(1+{psi})))-c1) ///
	(({beta}*(nu+r*nu+w1+r*w1+w2)/((1+{beta})*(1+{psi})))-c2) ///
	(((-nu*{psi}-r*nu*{psi}+w1+r*w1+{beta}*w1+r*{beta}*w1+{beta}*{psi}*w1+r*{beta}*{psi}*w1-{psi}*w2)/((1+r)*(1+{beta})*(1+{psi})*w1))-L1), winitial(identity) from(beta 1 psi 3)
