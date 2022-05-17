function ENE=jENE(X)
p = hist(X,32);
%ENE = -sum(p.*log2(p)) co to ???

ENE =sum(p.*p);
end