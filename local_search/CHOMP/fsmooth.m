function [ grad ] = fsmooth(xi, A, b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
grad = (size(xi,1)+1)*(A*xi+b);
end

