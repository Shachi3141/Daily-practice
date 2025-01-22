!Random sequential absorption of particles in a squre lattice
!length of the squre box is given(l) 

program RSA_sphere
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=500    !Give a number more than lattice point(used in memory allocation)
    integer, parameter :: max_count=1000       ! max_count is total iteration no
    integer :: i,j,n,count,particle_count,check
    real(dp),parameter :: l=20.0               !length of box = l
    real(dp)  :: density,x1,y1
    integer,allocatable,dimension(:) :: x,y
    integer(dp),allocatable,dimension(:,:) :: M

    allocate(x(max_particles),y(max_particles))

    n = int(l+1)
    allocate(M(0:int(l),0:int(l)))

    M = 0
    x=0
    y=0
    print*, 'Total no of lattice site = ', (n)**2
    
    open(1,file='2d_lattice_posn.txt',status='replace')
    open(2,file='2d_lattice_density.txt',status='replace')
    i=1
    particle_count=0
    count=0
    do j=1, max_count 
        count=count+1    
        call random_number(x1)
        call random_number(y1)
        x(i) =  nint(x1 * l)
        y(i) =  nint(y1 * l)

        call N3_check(x(i),y(i),M,check)
        !print*, 'check = ', check
        if (check == 0) then
            M(x(i),y(i)) = 1
            particle_count = particle_count + 1
            density=real(particle_count)/(n)**2
            write(2,'(i12, 1x, i12, 1x, f24.16)') count,particle_count,density
            write(1,'(i12, 1x, i12)') x(i),y(i)
            i=i+1
        else
            write(2,'(i12, 1x, i12, 1x, f24.16)') count,particle_count,density
        end if
        
    end do

    print*, 'particle_count = ', particle_count
    print*, 'Final density = ', density
    deallocate(x,y)
    deallocate(M)
    close(1)
    close(2)

    !!!!!!!!!!!!!!!!!!!!!!!!!! subroutines  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    contains
    subroutine N1_check(x,y,Matrix,check)
        implicit none
        ! THIS SUBROUTINE CHECK SITE (x,y) AND ITS N1 NEIGHBOURS OF THE MATRIX 'Matrix' IS FILLED OR NOT
        ! IF ANY ONE SITE IS OCCUPIED THEN RETURN %%%%% check = 1  OTHERWISE check = 0
        integer :: i,j
        integer,intent(in) :: x,y
        integer,intent(out) :: check
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix
        integer(dp),allocatable,dimension(:,:) :: Mi

    
        allocate(Mi(-1:int(l)+1,-1:int(l)+1))
        Mi = 0

        Mi(0:int(l),0:int(l)) = Matrix

        check = 0
        ! boundary condition
        Mi(-1,0:int(l)) =  Matrix(int(l),0:int(l))
        Mi(int(l)+1,0:int(l)) =  Matrix(0,0:int(l))
        Mi(0:int(l),-1) =  Matrix(0:int(l),int(l))
        Mi(0:int(l),int(l)+1) =  Matrix(0:int(l),0)


        do j = y - 1, y + 1
            if (Mi(x,j) == 1) then 
                check = 1
            end if
        end do
        do i = x - 1, x + 1
            if (Mi(i,y) == 1) then 
                check = 1
            end if
        end do



        ! print *, "lbound(Matrix, 1): ", lbound(Matrix, 1)
        ! print *, "ubound(Matrix, 1): ", ubound(Matrix, 1)
        ! print *, "lbound(a, 1): ", lbound(Mi, 1)
        ! print *, "ubound(a, 1): ", ubound(Mi, 1)

    end subroutine N1_check

    subroutine N2_check(x,y,Matrix,check)
        implicit none
        ! THIS SUBROUTINE CHECK SITE (x,y) AND ITS N2 NEIGHBOURS OF THE MATRIX 'Matrix' IS FILLED OR NOT
        ! IF ANY ONE SITE IS OCCUPIED THEN RETURN %%%%% check = 1  OTHERWISE check = 0
        integer :: i,j
        integer,intent(in) :: x,y
        integer,intent(out) :: check
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix
        integer(dp),allocatable,dimension(:,:) :: Mi

    
        allocate(Mi(-1:int(l)+1,-1:int(l)+1))
        Mi = 0

        Mi(0:int(l),0:int(l)) = Matrix

        check = 0
        ! boundary condition
        Mi(-1,0:int(l)) =  Matrix(int(l),0:int(l))
        Mi(int(l)+1,0:int(l)) =  Matrix(0,0:int(l))
        Mi(0:int(l),-1) =  Matrix(0:int(l),int(l))
        Mi(0:int(l),int(l)+1) =  Matrix(0:int(l),0)
        !Update corner (crucial for N2 and N3)
        Mi(-1,-1) =  Matrix(int(l),int(l))
        Mi(int(l)+1,int(l)+1) =  Matrix(0,0)
        Mi(int(l)+1,-1) =  Matrix(0,int(l))
        Mi(-1,int(l)+1) =  Matrix(int(l),0)

        ! N2 neighbours including the point
        do i = x - 1, x + 1
            do j = y - 1, y + 1
                if (Mi(i,j) == 1) then 
                    check = 1
                end if
            end do
         end do

    end subroutine N2_check


    subroutine N3_check(x,y,Matrix,check)
        implicit none
        integer :: i,j
        integer,intent(in) :: x,y
        integer,intent(out) :: check
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix
        integer(dp),allocatable,dimension(:,:) :: Mi

    
        allocate(Mi(-2:int(l)+2,-2:int(l)+2))
        Mi = 0

        Mi(0:int(l),0:int(l)) = Matrix

        check = 0
        ! boundary condition
        Mi(-1,0:int(l)) =  Matrix(int(l),0:int(l))
        Mi(-2,0:int(l)) =  Matrix(int(l)-1,0:int(l))

        Mi(int(l)+1,0:int(l)) =  Matrix(0,0:int(l))
        Mi(int(l)+2,0:int(l)) =  Matrix(1,0:int(l))

        Mi(0:int(l),-1) =  Matrix(0:int(l),int(l))
        Mi(0:int(l),-2) =  Matrix(0:int(l),int(l)-1)

        Mi(0:int(l),int(l)+1) =  Matrix(0:int(l),0)
        Mi(0:int(l),int(l)+2) =  Matrix(0:int(l),1)
        !Update corner (crucial for N2 and N3)
        Mi(-1,-1) =  Matrix(int(l),int(l))
        Mi(int(l)+1,int(l)+1) =  Matrix(0,0)
        Mi(int(l)+1,-1) =  Matrix(0,int(l))
        Mi(-1,int(l)+1) =  Matrix(int(l),0)


        ! Upto N2 neighbours and the point
        do i = x - 1, x + 1
            do j = y - 1, y + 1
                if (Mi(i,j) == 1) then 
                    check = 1
                end if
            end do
         end do

        ! Only N3 neighbours and the point
        do j = y - 2, y + 2, 2
            if (Mi(x,j) == 1) then 
                check = 1
            end if
        end do
        do i = x - 2, x + 2, 2
            if (Mi(i,y) == 1) then 
                check = 1
            end if
        end do

    end subroutine N3_check

end program RSA_sphere
