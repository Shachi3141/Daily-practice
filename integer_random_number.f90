! checking count of integer random number(0 to 3)
! using inbuilt real random number (0.0 to 1.0) 

program main
    implicit none
    integer :: i,randint03,c0,c1,c2,c3
    real(8) :: r1
    
    c0=0
    c1=0
    c2=0
    c3=0
    do i=1,4000
        call random_number(r1)
        r1 = -0.5 + (r1 * (3.5+0.5))
        randint03 = nint(r1)
        !print*, 'randint03 = ', randint03
        if (randint03==0) c0=c0+1
        if (randint03==1) c1=c1+1
        if (randint03==2) c2=c2+1
        if (randint03==3) c3=c3+1
    end do
    
    !print*, 'hsdghs = =', nint(-0.5)

    print*, 'c0 = ',c0
    print*, 'c1 = ',c1
    print*, 'c2 = ',c2
    print*, 'c3 = ',c3
end program main


! out put
c0 =         1000
c1 =         1005
c2 =         1005
c3 =          990
