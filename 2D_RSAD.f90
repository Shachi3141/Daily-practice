!Random sequential absorption of particles with diffusion in a squre lattice

program Diffusion_random
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=500    !Give a number more than lattice point(used in memory allocation)
    integer, parameter :: max_count=10000       ! max_count is total iteration no
    integer :: i,j,n,count,particle_count,check,t
    real(dp),parameter :: l=19.0               !length of box = l
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
    
    open(1,file='2d_RSAD.txt',status='replace')
    open(2,file='2d_RSAD_density.txt',status='replace')
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
        ! Check if possible fill and increase index, also 
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
    
    print*, 'Before diffusion particle_count = ', particle_count
    print*, ' Before Final density = ', density

    ! Time step and diffusion after almost saturate. 
    do t=1,1000
        ! call routine for diffusion
        call random_diffuse(M)
        count=count+1    
        call random_number(x1)
        call random_number(y1)
        x(i) =  nint(x1 * l)
        y(i) =  nint(y1 * l)

        call N3_check(x(i),y(i),M,check)
        ! Check, if possible fill and increase index, also 
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


    subroutine Only_N3_check(x,y,Matrix,check)
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


        ! Only N3 neighbours 
        do j = y - 2, y + 2, 2
            if (j /= y) then
                if (Mi(x,j) == 1) then 
                    check = 1
                end if
            end if
        end do
        do i = x - 2, x + 2, 2
            if (i /= x) then
                if (Mi(i,y) == 1) then 
                    check = 1
                end if
            end if
        end do
        ! N1 and N2 
        do i = x - 1, x + 1
            do j = y - 1, y + 1
                if (i /= x .or. j /= y) then
                    if (Mi(i,j) == 1) then 
                        check = 1
                    end if
                end if
            end do
         end do

    end subroutine Only_N3_check

    subroutine random_diffuse(Matrix)
        implicit none
        integer :: i,j,imax,imin,check,randint03
        real(dp) :: r1
        integer(dp),allocatable,dimension(:,:), intent(inout) :: Matrix
        integer(dp),allocatable,dimension(:,:) :: Mi


        check = 0
        imax = ubound(Matrix, 1)
        imin = lbound(Matrix, 1)
        
        ! allocate dummy matrix with extra rows and column for PBC 
        allocate(Mi(-1:int(l)+1,-1:int(l)+1))
        Mi = 0

        do i=imin, imax
            do j=imin, imax
                if (Matrix(i,j) == 1 ) then
                    !update dummy matrix
                    Mi(0:int(l),0:int(l)) = Matrix
                    ! boundary condition
                    Mi(-1,0:int(l)) =  Matrix(int(l),0:int(l))
                    Mi(int(l)+1,0:int(l)) =  Matrix(0,0:int(l))
                    Mi(0:int(l),-1) =  Matrix(0:int(l),int(l))
                    Mi(0:int(l),int(l)+1) =  Matrix(0:int(l),0)

                    call Only_N3_check(i,j,Matrix,check)
                    if (check == 0) then
                        call random_number(r1)
                        r1 = -0.5 + (r1 * (3.5+0.5))
                        randint03 = nint(r1)

                        select case (randint03)
                        case (0)
                            Mi(i-1, j) = 1
                            Mi(i, j) = 0
                        case (1)
                            Mi(i+1, j) = 1
                            Mi(i, j) = 0
                        case (2)
                            Mi(i, j-1) = 1
                            Mi(i, j) = 0
                        case (3)
                            Mi(i, j+1) = 1
                            Mi(i, j) = 0
                        end select
                    end if

                    ! Update original Matrix 
                    Matrix(0:int(l),0:int(l)) = Mi(0:int(l),0:int(l))
                    ! boundary condition
                    if (i == 0) Matrix(int(l),0:int(l)) = Mi(-1,0:int(l)) 
                    if (i == int(l)) Matrix(0,0:int(l)) = Mi(int(l)+1,0:int(l)) 
                    if (j == 0) Matrix(0:int(l),int(l)) = Mi(0:int(l),-1)
                    if (j == int(l)) Matrix(0:int(l),0) = Mi(0:int(l),int(l)+1)
                end if

            end do 
        end do



    end subroutine random_diffuse

end program Diffusion_random
