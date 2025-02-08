!Random sequential absorption of particles with diffusion in a squre lattice

program Diffusion_random
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=500     ! used in memory allocation
    integer, parameter :: max_count=1E6          ! max_count is total iteration no for RSA
    integer, parameter :: diffu_count=1E6
    real(dp),parameter :: e=0.01
    integer :: i,j,k,n,count,particle_count,check,t,x2,y2,step
    real(dp),parameter :: l=39.0               !length of box = l
    real(dp)  :: density,x1,y1,g
    integer,allocatable,dimension(:) :: x,y
    integer(dp),allocatable,dimension(:,:) :: M

    allocate(x(max_particles),y(max_particles))

    !number of particle in a row
    n = int(l+1)
    allocate(M(0:int(l),0:int(l)))

    M = 0
    x=0
    y=0
    print*, 'Total no of lattice site = ', (n)**2
    print*, 'Site alocation no(max_particles)= ', max_particles
    
    open(1,file='2d_RSAD.txt',status='replace')
    open(3,file='2d_RSAD_diffu.txt',status='replace')
    open(5,file='density.txt',status='replace')
    
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
            write(1, '(i12, 1x, i12)') x(i), y(i)
            i=i+1  
        end if

        
    end do
    
    print*, 'Before diffusion particle_count = ', particle_count
    print*, ' Before diffusion Final density = ', density


    !!!!!!!!!!!!!!!!!!!!!!!!!! LOOP FOR DIFFUSE  !!!!!!!!!!!!!!!!!!!!!!!!!!!

    g = 0.0
    
    ! Time step and diffusion after almost saturate. 
    do t=1,diffu_count
        ! call routine for diffusion
        call random_diffuse(M)

        call random_number(x1)
        call random_number(y1)
        
        x2 =  nint(x1 * l)
        y2 =  nint(y1 * l)

        call N3_check(x2,y2,M,check)
        ! Check, if possible fill 
        if (check == 0) then
            M(x2,y2) = 1
            particle_count = particle_count + 1
            density=real(particle_count)/(n)**2

            step = max(1, 10**int(log10(real(max(1, t)))))  ! Determines steps dynamically
            if (mod(t, step) == 0) then
                write(5,'(f24.16, 1x, f24.16)') e*t, density
            end if
        else
            step = max(1, 10**int(log10(real(max(1, t)))))  ! Determines steps dynamically
            if (mod(t, step) == 0) then
                write(5,'(f24.16, 1x, f24.16)') e*t, density
            end if
        end if

    end do

    do j=0, int(l)
        do k=0, int(l)
            if (M(j,k) == 1) then
                write(3,'(i12, 1x, i12)') j, k
            end if
        end do
    end do


    print*, 'particle_count = ', particle_count
    print*, 'Final density = ', density
    
    deallocate(x,y)
    deallocate(M)

    close(1)
    close(3)
    close(5)

    !!!!!!!!!!!!!!!!!!!!!!!!!! subroutines  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    contains
    subroutine N3_check(x,y,Matrix,check)
        implicit none
        integer :: i,j,k
        integer, dimension(4) ::dx1,dy1, dx2,dy2,dx3,dy3
        integer,intent(in) :: x,y
        integer,intent(out) :: check
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix

        check = 0

        ! At the point
        if (Matrix(x,y) == 1) then 
            check = 1
        end if
        ! Nearest neighbor displacements (±1 along x or y)
        dx1 = (/ -1,  1,  0,  0 /)
        dy1 = (/  0,  0, -1,  1 /)

        do k = 1, 4
        i=x + dx1(k)
        j=y + dy1(k)
        call PB(i,j)
        if (Matrix(i,j) == 1) then 
            check = 1
        end if
        end do
        ! Next-nearest neighbor displacements (diagonal)
        dx2 = (/ -1, -1,  1,  1 /)
        dy2 = (/ -1,  1, -1,  1 /)

        do k = 1, 4
            i=x + dx2(k)
            j=y + dy2(k)
            call PB(i,j)
            if (Matrix(i,j) == 1) then 
                check = 1
            end if
        end do

        ! Third-nearest neighbor displacements (±2 along x or y)
        dx3 = (/ -2,  2,  0,  0 /)
        dy3 = (/  0,  0, -2,  2 /)

        do k = 1, 4
            i=x + dx3(k)
            j=y + dy3(k)
            call PB(i,j)
            if (Matrix(i,j) == 1) then 
                check = 1
            end if
        end do
    end subroutine N3_check


    subroutine Only_N3_check(x,y,Matrix,check)
        implicit none
        integer :: i,j,k
        integer, dimension(4) ::dx1,dy1, dx2,dy2,dx3,dy3
        integer,intent(in) :: x,y
        integer,intent(out) :: check
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix

        check = 0
        
        ! Nearest neighbor displacements (±1 along x or y)
        dx1 = (/ -1,  1,  0,  0 /)
        dy1 = (/  0,  0, -1,  1 /)

        do k = 1, 4
        i=x + dx1(k)
        j=y + dy1(k)
        call PB(i,j)
        if (Matrix(i,j) == 1) then 
            check = 1
        end if
        end do
        ! Next-nearest neighbor displacements (diagonal)
        dx2 = (/ -1, -1,  1,  1 /)
        dy2 = (/ -1,  1, -1,  1 /)

        do k = 1, 4
            i=x + dx2(k)
            j=y + dy2(k)
            call PB(i,j)
            if (Matrix(i,j) == 1) then 
                check = 1
            end if
        end do

        ! Third-nearest neighbor displacements (±2 along x or y)
        dx3 = (/ -2,  2,  0,  0 /)
        dy3 = (/  0,  0, -2,  2 /)

        do k = 1, 4
            i=x + dx3(k)
            j=y + dy3(k)
            call PB(i,j)
            if (Matrix(i,j) == 1) then 
                check = 1
            end if
        end do

    end subroutine Only_N3_check

    subroutine random_diffuse(Matrix)
        implicit none
        integer :: i,j,ii,jj,check,randint03
        real(dp) :: r1
        integer(dp),allocatable,dimension(:,:), intent(inout) :: Matrix
        check = 0
        
        do i=0, int(l)
            do j=0, int(l)

                if (Matrix(i,j) == 1 ) then
                        call random_number(r1)
        
                        randint03 = floor(4*r1)

                        select case (randint03)
                        case (0)
                            ii = i-1
                            call PB1(ii)
                            Matrix(ii, j) = 1
                            Matrix(i, j) = 0
                            call Only_N3_check(ii,j,Matrix,check)
                            if (check == 1) then
                                Matrix(ii, j) = 0
                                Matrix(i, j) = 1
                            end if
                        case (1)
                            ii = i+1
                            call PB1(ii)
                            Matrix(ii, j) = 1
                            Matrix(i, j) = 0
                            call Only_N3_check(ii,j,Matrix,check)
                            if (check == 1) then
                                Matrix(ii, j) = 0
                                Matrix(i, j) = 1
                            end if
                        case (2)
                            jj = j-1
                            call PB1(jj)
                            Matrix(i, jj) = 1
                            Matrix(i, j) = 0
                            call Only_N3_check(i,jj,Matrix,check)
                            if (check == 1) then
                                Matrix(i, jj) = 0
                                Matrix(i, j) = 1
                            end if
                        case (3)
                            jj = j+1
                            call PB1(jj)
                            Matrix(i, jj) = 1
                            Matrix(i, j) = 0
                            call Only_N3_check(i,jj,Matrix,check)
                            if (check == 1) then
                                Matrix(i, jj) = 0
                                Matrix(i, j) = 1
                            end if
                        end select
                end if

            end do 
        end do



    end subroutine random_diffuse


    subroutine PB(x,y)
        implicit none
        integer,intent(inout) :: x,y
        integer :: ll

        ll = int(l)

        if (x > ll ) x = x - ll -1
        if (y > ll ) y = y - ll -1
        if (x < 0 ) x = x + ll +1
        if (y < 0 ) y = y + ll +1

    end subroutine PB

    subroutine PB1(x)
        implicit none
        integer,intent(inout) :: x
        integer :: ll

        ll = int(l)

        if (x > ll ) x = x - ll -1
        if (x < 0 ) x = x + ll +1

    end subroutine PB1


end program Diffusion_random