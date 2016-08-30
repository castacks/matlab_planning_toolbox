function D = pdist2r(A,B)

%from this source:
% http://stackoverflow.com/questions/7696734/pdist2-equivalent-in-matlab-version-7
D = sqrt( bsxfun(@plus,sum(A.^2,2),sum(B.^2,2)') - 2*(A*B') );

end