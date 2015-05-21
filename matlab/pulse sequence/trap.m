function t = trap(tot_length,tail_length)

if tail_length*2>tot_length error('trapazoid tail length too long'); end

t=zeros(tot_length,1);
t(1:tail_length)=(1:tail_length)/tail_length;
t((end-tail_length+1):end)=(tail_length:-1:1)/tail_length;
t(tail_length+1:end-tail_length)=1;