% function [alphat, yt, thetat] = lowertri(xt, d)
% this is a matlab function called lowertri()
%
% inputs:  ...
% outputs: ...
% usage: 
%     [alphat, yt, thetat] = lowertri(xt, d)
%     where ... 

function [alphat, yt, thetat] = lowertri(xt, d)

alphat = acos(xt/(2*d));
yt = d*sin(alphat);
thetat = pi - 2*alphat;
