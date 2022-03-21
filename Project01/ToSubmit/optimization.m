clc;clear;close all;

V = [76;0];
[a,b] = fmincon(@(x) totalLift(x,V),[30;1;0.5],[],[],[],[],[0;0.2;0.5],[40;2;0.9])