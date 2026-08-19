program model1
implicit none

integer, parameter:: stps=100000, N=256
real, parameter:: devQ=sqrt(0.002), devM=sqrt(10000.), devN=sqrt(50.), sigma1=0.683, sigma2=0.954, sigma3=0.997

integer, dimension(1:stps):: num          
integer:: i, j, reject 
character(100), dimension(1:N):: dinoName                  
real, dimension(1:N):: dataMass, dev10Mass
real, dimension(1:stps):: M1, Q, likely, post, postNorm   
real:: r, a, saveValue, Z
real:: pGauss, randomGauss, modelMass   


call random_seed()

open(100, file='ListaGrado2_t.txt', status='old', action='read')
open(101, file='posteriorDinoT.txt')

read(100,*) 

do i=1,N
  read(100,*) dinoName(i), dataMass(i), dev10Mass(i)
end do

M1(1)=dataMass(1)
Q(1)=1.
num(1)=10

likely(1)=1.
do i=1,num(1)
  likely(1)=likely(1)*pGauss(log10(dataMass(i)),log10(modelMass(M1(1),Q(1),i*1.)),dev10Mass(i))
end do

post(1)=likely(1)*pGauss(M1(1),M1(1),devM)*pGauss(Q(1),Q(1),devQ)*pGauss(num(1)*1.,num(1)*1.,devN)

reject=0

do i=1,stps-1
  r=randomGauss(num(i)*1.,devN)  
  if (INT(r).gt.1.and.INT(r).lt.N) then
    num(i+1)=INT(r)
  else
    num(i+1)=num(i)
  end if
  
  r=randomGauss(Q(i),devQ)
  if (r.gt.0.) then
    Q(i+1)=r
  else
    Q(i+1)=Q(i)
  end if
  
  M1(i+1)=randomGauss(M1(1),devM)

likely(i+1)=1.
do j=1,num(i+1)
  likely(i+1)=likely(i+1)*pGauss(log10(dataMass(j)),log10(modelMass(M1(i+1),Q(i+1),j*1.)),dev10Mass(j))
end do

 a=Likely(i+1)/Likely(i)

 if (a.lt.1) then 
     call random_number(r)
     if (r.gt.a) then
        Q(i+1)=Q(i)
        M1(i+1)=M1(i)
        num(i+1)=num(i)
        Likely(i+1)=Likely(i)
        reject=reject+1
     end if
  end if

post(i+1)=likely(i+1)*pGauss(M1(i),M1(i+1),devM)*pGauss(Q(i),Q(i+1),devQ)*pGauss(num(i)*1.,num(i+1)*1.,devN)


end do

Z=0.
do i=1,stps
  Z=Z+post(i)
end do

write(101,*)""
do i=1,stps
  postNorm(i)=post(i)/Z
  if (20*i.gt.stps) then
    write(101,*) M1(i)," ",Q(i)," ",num(i)," ",postNorm(i)
  end if
end do

do i=1,stps-1
  do j=i+1,stps
     if (postNorm(i).lt.postNorm(j)) then
        saveValue=postNorm(i) 
        postNorm(i)=postNorm(j)
        postNorm(j)=saveValue 
     end if
  end do
end do

write(*,*)"acceptance rate (%): ",100.* (stps-reject)/stps

saveValue=0.
do i=1,stps
  saveValue=saveValue+postNorm(i)
  if (saveValue.gt.sigma1) then
     write(*,*)"1-sigma Posterior-cut: ",postNorm(i)
     EXIT
  end if
end do

saveValue=0.
do i=1,stps
  saveValue=saveValue+postNorm(i)
  if (saveValue.gt.sigma2) then
     write(*,*)"2-sigma Posterior-cut: ",postNorm(i)
     EXIT
  end if
end do

saveValue=0.
do i=1,stps
  saveValue=saveValue+postNorm(i)
  if (saveValue.gt.sigma3) then
     write(*,*)"3-sigma Posterior-cut: ",postNorm(i)
     EXIT
  end if
end do

close(100)
close(101)
end    
!--------------------------Functions:
real function modelMass(M1,Q,x)
implicit none
  
real:: M1,Q,x
   
modelMass=M1*x**(-Q)

end
!--------------------------
real function pGauss(yt,yd,dev)
implicit none

real:: yd,yt,dev
real:: pi=acos(-1.0)

pGauss=(sqrt(2*pi)*dev)**(-1)*exp(-(yt-yd)**2/(2*dev**2))

end
!--------------------------
real function randomGauss(x0,dev)
implicit none

real:: x0,dev,a,b
real:: pi=acos(-1.0)
  
call random_number(a)
call random_number(b)

randomGauss=x0+(sqrt(-2*log(a))*cos(2*pi*b))*dev

end


