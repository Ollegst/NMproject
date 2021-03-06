;; 1. Based on: run1
;; 2. Description: 1CMT+oral
;; x1. Author: John Smith

$PROBLEM ...

;; 4. Date: 01.01.2011
;; 5. Version: 1
;; 6. Label:
;; Basic model
;; 7. Structural model:
;; One compartment model
;; 8. Covariate model:
;; No covariates
;; 9. Inter-individual variability:
;; CL and V1.
;; 10. Inter-occasion variability:
;; No IOV
;; 11. Residual variability:
;; Additive + Proportional
;; 12. Estimation:
;; IMP

$INPUT ...
$DATA ... IGNORE=@ 
$SUB ADVAN2

$PK

TVKA=EXP(THETA(1))
MU_1=LOG(TVKA)
KA = EXP(MU_1+ETA(1))

TVK=EXP(THETA(2))
MU_2=LOG(TVK)
K = EXP(MU_2+ETA(2))

TVV=EXP(THETA(3))
MU_3=LOG(TVV)
V = EXP(MU_3+ETA(3))

CL = K*V

S2 = V

$ERROR 

IPRED=F
W=SQRT(THETA(4)**2+THETA(5)**2*IPRED*IPRED)  ; proportional + additive error
IRES=DV-IPRED
IWRES=IRES/W
Y=IPRED+W*EPS(1)


$THETA
.....          	; KA ; h-1 ; LOG
.....          	; K  ; h-1 ; LOG
.....          	; V  ; L ; LOG
.....          	; add error
.....          	; prop error

$OMEGA
0.03			; IIV_KA ; LOG
0.03			; IIV_K ; LOG
0.03			; IIV_V ; LOG

$SIGMA
1 FIX

; Parameter estimation - FOCE
;$EST METHOD=1 INTER NOABORT MAXEVAL=9999 PRINT=1 NSIG=3 SIGL=9

; Parameter estimation - IMP
$EST METHOD=IMP ISAMPLE=300 NITER=300 RANMETHOD=3S2
CTYPE=3 CITER=10 CALPHA=0.05 CINTERVAL=3
PRINT=1 NOABORT INTERACTION GRD=DDDSS

; Parameer estimation - SAEM
;$EST METHOD=SAEM ISAMPLE=2 NBURN=1000 NITER=500 RANMETHOD=3S2
;CTYPE=3 CITER=10 CALPHA=0.05 CINTERVAL=10
;PRINT=1 NOABORT INTERACTION GRD=DDDSS

; Objective function and covariance evaluation
$EST METHOD=IMP INTER EONLY= 1 MAPITER=0 ISAMPLE = 2000 NITER = 10 RANMETHOD=3S2 NOABORT PRINT=1 NSIG=3 SIGL=9 GRD=DDDSS

$COV PRINT=E UNCONDITIONAL SIGL=10

$TABLE ID TIME IPRED IWRES IRES CWRES NPDE
FILE=sdtab1 NOPRINT ONEHEADER FORMAT=tF13.4
$TABLE ID ; individual parameters
FILE=patab1 NOPRINT ONEHEADER FORMAT=tF13.4
$TABLE ID ; continuous covariates
FILE=cotab1 NOPRINT ONEHEADER FORMAT=tF13.4
$TABLE ID ; categorical covariates
FILE=catab1 NOPRINT ONEHEADER FORMAT=tF13.4
