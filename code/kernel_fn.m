function Kx = kernel_fn( x, sigma )
% http://info.ee.surrey.ac.uk/CVSSP/Publications/papers/Mikolajczyk-PAMI-2005c.pdf
Kx = (1.0/(sqrt(2*pi)*sigma)) * exp ((-0.5)*(x.^2)/(sigma^2));  

end

