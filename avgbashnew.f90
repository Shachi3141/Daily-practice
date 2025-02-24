! Corrected code on with input file name (for bash)
! 2D RSAD 

program Diffusion_random
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=400    ! used in memory allocation
    integer, parameter :: max_count=1E6         ! max_count is total iteration no for RSA
    integer, parameter :: diffu_count=1E6
    integer, parameter, dimension(6) :: i_c = (/ 2, 4, 6, 5, 1, 2 /)
    integer, parameter, dimension(6) :: j_c = (/ 1, 2, 3, 0, 2, 4/)
    real(dp),parameter :: e=0.01
    integer :: i,j,k,n,count,particle_count,check,step
    real(dp),parameter :: l=19.0               !length of box = l
    real(dp) , dimension(6) :: g
    real(dp)  :: density,x1,y1
    real(dp) :: r1
    integer :: ii,jj,randint03,ios
    integer,allocatable,dimension(:) :: x,y
    integer(dp),allocatable,dimension(:,:) :: M
    character(len=56) :: filename1, filename2, filename3, filename4


    ! Read filename from command line
    call get_command_argument(1, filename1)
    call get_command_argument(2, filename2)
    call get_command_argument(3, filename3)
    call get_command_argument(4, filename4)


    ! filename1='RSAD_diffu.txt'
    ! filename2='RSAD_density.txt'
    ! filename3='gij.txt'
    ! filename4='g.txt'

    allocate(x(max_particles),y(max_particles))
    !number of particle in a row
    n = int(l+1)
    allocate(M(0:int(l),0:int(l)))

    M = 0
    x=0
    y=0
    print*, 'Total no of lattice site = ', (n)**2
    print*, 'Site alocation no(max_particles)= ', max_particles
    
    ios = 0
    open(30, file=trim(filename1),status="unknown", action="write", iostat=ios)
    open(40, file=trim(filename2),status="unknown", action="write", iostat=ios)
    open(50, file=trim(filename3),status="unknown", action="write", iostat=ios)
    open(500, file=trim(filename4),status="unknown", action="write", iostat=ios)
    if (ios /= 0) then
        print *, "Error: Unable to open file "
        stop
    end if
    
    
    i=1
    particle_count=0
    count=0

    
    do j=1, max_count 
        count=count+1    
        call random_number(x1)
        call random_number(y1)
        x(i) =  floor(x1 * (l+1))
        y(i) =  floor(y1 * (l+1))
        
        call N3_check(x(i),y(i),M,check)
        ! Check if possible fill and increase index, also 
        if (check == 0) then
            M(x(i),y(i)) = 1
            particle_count = particle_count + 1
            density=real(particle_count)/(n)**2
            i=i+1
        end if

        
    end do
    
    print*, 'Before diffusion particle_count = ', particle_count
    print*, ' Before diffusion Final density = ', density


    !!!!!!!!!!!!!!!!!!!!!!!!!! LOOP FOR DIFFUSE  !!!!!!!!!!!!!!!!!!!!!!!!!!!

    
    g = 0.0
    
    ! Time step and diffusion after almost saturate. 
    do count=0,diffu_count
        ! call routine for diffusion
        ! call random_diffuse(M)  (## DONT NEED TO CALL ##)

        check = 0
        do i=0, int(l)
            do j=0, int(l)
                if (M(i,j) == 1 ) then

                    call random_number(r1)
                    if ( r1 < e) then
                        call random_number(r1)
                        randint03 = floor(4*r1)

                        select case (randint03)
                        case (0)
                            ii = i-1
                            call PB1(ii)
                            M(ii, j) = 1
                            M(i, j) = 0
                            call Only_N3_check(ii,j,M,check)
                            if (check == 1) then
                                M(ii, j) = 0
                                M(i, j) = 1
                            end if
                        case (1)
                            ii = i+1
                            call PB1(ii)
                            M(ii, j) = 1
                            M(i, j) = 0
                            call Only_N3_check(ii,j,M,check)
                            if (check == 1) then
                                M(ii, j) = 0
                                M(i, j) = 1
                            end if
                        case (2)
                            jj = j-1
                            call PB1(jj)
                            M(i, jj) = 1
                            M(i, j) = 0
                            call Only_N3_check(i,jj,M,check)
                            if (check == 1) then
                                M(i, jj) = 0
                                M(i, j) = 1
                            end if
                        case (3)
                            jj = j+1
                            call PB1(jj)
                            M(i, jj) = 1
                            M(i, j) = 0
                            call Only_N3_check(i,jj,M,check)
                            if (check == 1) then
                                M(i, jj) = 0
                                M(i, j) = 1
                            end if
                        end select


                        ! diposit particle if possible
                        call random_number(x1)
                        call random_number(y1)
                        ! Although x(i), y(i) are not unique after diffu(M is impo) 
                        x(i) =  floor(x1 * (l+1))
                        y(i) =  floor(y1 * (l+1))

                        call N3_check(x(i),y(i),M,check)
                        ! Check, if possible fill and increase index i also 
                        if (check == 0) then
                            M(x(i),y(i)) = 1
                            particle_count = particle_count + 1

                        end if

                    end if
                    
                end if

            end do 
        end do


    
        step = max(1, 10**int(log10(real(max(1, count)))))  ! Determines steps dynamically
        if (mod(count,step ) == 0) then 
            density=real(particle_count)/(n)**2
            ! call gij calculator
            call gij(i_c,j_c,M,g)
            write(40,'(f18.8, 1x, f18.8)') e * count, density
            flush(40)
            write(50,'(7f18.8)') e * count, (g(1) - density)/(1 - density),(g(2) - density)/(1 - density),&
            (g(3) - density)/(1 - density), (g(4) - density)/(1 - density), (g(5) - density)/(1 - density), (g(6) - density)/(1 - density)
            flush(50)
            write(500,'(7f18.8)') e * count, g(1),g(2),g(3),g(4),g(5),g(6)
            flush(500)
            i=i+1
        end if

    end do



    do j=0, int(l)
        do k=0, int(l)
            if (M(j,k) == 1) then
                write(30,'(i12, 1x, i12)') j, k
                flush(30)
            end if
        end do
    end do


    print*, 'particle_count = ', particle_count
    print*, 'Final density = ', density
    
    deallocate(x,y)
    deallocate(M)
   
    close(30)
    close(40)
    close(50)
    close(500)
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

    ! subroutine random_diffuse(Matrix)
    !     implicit none
    !     integer :: i,j,ii,jj,check,randint03
    !     real(dp) :: r1
    !     integer(dp),allocatable,dimension(:,:), intent(inout) :: Matrix

    !     check = 0
        

    !     do i=0, int(l)
    !         do j=0, int(l)
    !             if (Matrix(i,j) == 1 ) then

    !                 call random_number(r1)
    !                 if ( r1 < e) then
    !                     call random_number(r1)
    !                     randint03 = floor(4*r1)

    !                     select case (randint03)
    !                     case (0)
    !                         ii = i-1
    !                         call PB1(ii)
    !                         Matrix(ii, j) = 1
    !                         Matrix(i, j) = 0
    !                         call Only_N3_check(ii,j,Matrix,check)
    !                         if (check == 1) then
    !                             Matrix(ii, j) = 0
    !                             Matrix(i, j) = 1
    !                         end if
    !                     case (1)
    !                         ii = i+1
    !                         call PB1(ii)
    !                         Matrix(ii, j) = 1
    !                         Matrix(i, j) = 0
    !                         call Only_N3_check(ii,j,Matrix,check)
    !                         if (check == 1) then
    !                             Matrix(ii, j) = 0
    !                             Matrix(i, j) = 1
    !                         end if
    !                     case (2)
    !                         jj = j-1
    !                         call PB1(jj)
    !                         Matrix(i, jj) = 1
    !                         Matrix(i, j) = 0
    !                         call Only_N3_check(i,jj,Matrix,check)
    !                         if (check == 1) then
    !                             Matrix(i, jj) = 0
    !                             Matrix(i, j) = 1
    !                         end if
    !                     case (3)
    !                         jj = j+1
    !                         call PB1(jj)
    !                         Matrix(i, jj) = 1
    !                         Matrix(i, j) = 0
    !                         call Only_N3_check(i,jj,Matrix,check)
    !                         if (check == 1) then
    !                             Matrix(i, jj) = 0
    !                             Matrix(i, j) = 1
    !                         end if
    !                     end select



    !                 end if
                    
    !             end if

    !         end do 
    !     end do



    ! end subroutine random_diffuse

    subroutine gij(x,y,Matrix,g)
        implicit none
        integer :: i,j,ii,jj,p_count,k
        integer,dimension(6),intent(in) :: x,y
        real(dp),dimension(6),intent(out) :: g
        integer(dp),allocatable,dimension(:,:), intent(inout) :: Matrix

        g=0.0
        p_count = 0
        
        ! 
        do i = 0, int(l)
            do j = 0, int(l)
                if (Matrix(i,j) == 1) then
                    p_count = p_count + 1
                    do k = 1,6
                        ii = i+x(k)
                        jj = j+y(k)
                        !Periodic boundary
                        call PB(ii,jj)
                        if (Matrix(ii,jj) == 1) then 
                            g(k) = g(k) + 1.0
                        end if
                    end do

                    
                end if
            end do
         end do
         g = g / p_count

    end subroutine gij

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
