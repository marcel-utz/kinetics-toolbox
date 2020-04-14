(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



Print["Kinetics Toolbox v0.0.2\n(c)2018 Marcel Utz"]


Format[Reaction[A_-> B_,k_]] := Infix[f[A,B],Labeled["\[LongRightArrow]",k,{Top}]]


Educts[  Reaction[Q_-> Y_,___] | Transport[Q_-> Y_,___]  ]  := Flatten[{Q  /. {Plus->List,A_Symbol|A_Subscript->Coeff[A,-1],Times[n_Integer,A_Symbol|A_Subscript]->Coeff[A,-n]} }] ;
Educts[ S_Source | S_Supply] := {} ;


 Products[  Reaction[Q_-> Y_,___] |  Transport[Q_-> Y_,___]]  := Flatten[ { Y  /. {Plus->List,A_Symbol|A_Subscript->Coeff[A,1],Times[n_Integer,A_Symbol|A_Subscript]->Coeff[A,n]} } ] ;
 Products[ Source[A_Symbol | A_Subscript,___] ] := {Coeff[A,1]} ;
 Products[ Supply[A_Symbol | A_Subscript,___] ] := {Coeff[A,1]} ;


RateExpression[A_Reaction,S_,t_,___] := 
A[[2]] Product[ l[[1]][t] ^ (-l[[2]]),{l,Educts[A]}]


RateExpression[Transport[Q_->Y_,k1_,k2_],S_,t_] :=  If[S===Q, k1 Q[t], If[S===Y,k2 Q[t],0]]


RateExpression[Source[Y_Symbol|Y_Subscript,y0_,k_],S_,t_] := If[S===Y, k(y0-Y[t]),0]


RateExpression[Supply[Q_Symbol|Q_Subscript,k_],S_,t_] := If[S===Q,k,0]


StoichiometricCoefficient[R_Reaction|R_Transport|R_Source|R_Supply, S_Symbol | S_Subscript] :=
  Module[{m=Join[Educts[R],Products[R]]},
Total[Cases[m,Coeff[S,k_]:> k] /. _Missing->0 ]]


RateEquation[Reac_List, S_Symbol | S_Subscript, t_] := Module[{},
D[S[t],t]==Sum[ RateExpression[r,S,t] StoichiometricCoefficient[r,S],{r,Reac}]
]


ReactionSpecies[R_Reaction | R_Transport | R_Source] :=  Join[Educts[R],Products[R]] /. Coeff[A_,_]->A ;
SetAttributes[ReactionSpecies,Listable]


EqReaction[A_ ->  B_ , k1_,k2_] := Sequence[
Reaction [A->B, k1], Reaction[B->A,k2]]


Transport[{A_},{B_},k1_,k2_] :=  Transport[A->B,k1,k2];
Transport[A_List,B_List,k1_,k2_] := 
 Sequence[Transport[First[A]->First[B],k1,k2], Transport[Rest[A],Rest[B],k1,k2]] ;


CompleteInitialConditions[vars_, conds_] := 
Module[ {m,  q=conds/. a_[_]==_ ->a },
v=Complement[vars,q];
Join[conds,Table[k[0]==0,{k,v}]]
]


RegionIndices[vars_List,subs_Symbol] := Table[ s->Subscript[s,subs],{s,vars}]



