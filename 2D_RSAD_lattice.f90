!Random sequential absorption of particles with diffusion in a squre lattice

program Diffusion_random
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=800    ! used in memory allocation
    integer, parameter :: max_count=1E5         ! max_count is total iteration no for RSA
    integer, parameter :: diffu_count=1E6
    integer, parameter :: ens_no = 20
    integer, parameter, dimension(4) :: i_c = (/ 2, 4, 6, 5 /)
    integer, parameter, dimension(4) :: j_c = (/ 1, 2, 3, 0 /)
    real(dp),parameter :: e=0.01
    integer :: i,j,k,n,count,particle_count,check,t,ii,step
    real(dp),parameter :: l=39.0               !length of box = l
    real(dp)  :: density,x1,y1
    integer,allocatable,dimension(:) :: x,y
    integer(dp),allocatable,dimension(:,:) :: M
    real(dp) ,allocatable, dimension(:,:) ::g_array , g_array_sum
    real(dp) ,allocatable, dimension(:) :: density_array, density_array_sum

    allocate(x(max_particles),y(max_particles))
    allocate(M(0:int(l),0:int(l)))
    allocate(density_array(diffu_count),density_array_sum(diffu_count))
    allocate(g_array(diffu_count,4),g_array_sum(diffu_count,4))
    
    !number of particle in a row
    n = int(l+1)
    print*, 'Total no of lattice site = ', (n)**2
    print*, 'Site alocation no(max_particles)= ', max_particles
    flush(6)

    open(1,file='2d_RSAD.txt',status='replace')
    open(2,file='2d_RSAD_density.txt',status='replace')
    open(3,file='2d_RSAD_diffu.txt',status='replace')
    open(4,file='2d_RSAD_density_diffu.txt',status='replace')
    open(5,file='gij.txt',status='replace')


    
    density_array_sum(:) = 0
    g_array_sum(:,:) = 0

    do ii=1,ens_no
        M = 0
        x = 0
        y = 0

        ! RSA upto saturation
        call RSA( M, x, y, density, particle_count)

        print*, " "
        print*, 'Before diffusion particle_count = ', particle_count
        print*, ' Before diffusion Final density = ', density
        flush(6)

        ! diffusion for one ensemble
        call RSAD(M,particle_count,g_array,density_array)


        print*, 'After diffusion Particle count = ', nint(density_array(diffu_count)*n**2)
        print*, 'Final density = ', density_array(diffu_count)
        flush(6)

        density_array_sum(:) = density_array_sum(:) + density_array(:)
        g_array_sum(:,:) = g_array_sum(:,:) + g_array(:,:)
    end do

    ! Writing in file
    do t=0, diffu_count

        step = max(1, 10**int(log10(real(max(1, t)))))  ! Determines steps dynamically

        if (mod(t, step) == 0) then
        write(4,'(f12.6, 1x, f24.16)') e * t, density_array_sum(t)/ ens_no
        write(5,'(5f12.7)') e * t, (g_array_sum(t,1)/ens_no), (g_array_sum(t,2)/ens_no ), (g_array_sum(t,3)/ens_no ),(g_array_sum(t,4)/ens_no )
        end if
    end do
    
    print*, "DONE !!!!!!!!!!! "
    flush(6)

    deallocate(g_array,density_array,g_array_sum,density_array_sum)
    deallocate(x,y)
    deallocate(M)
    close(1)
    close(2)
    close(3)
    close(4)
    close(5)

    !!!!!!!!!!!!!!!!!!!!!!!!!! subroutines  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    contains

    subroutine RSA( M, x, y, density, particle_count)
        implicit none
        integer :: n
        integer(dp),allocatable, dimension(:,:), intent(inout) :: M
        integer,allocatable, dimension(:), intent(inout) :: x, y
        real(dp), intent(out) :: density
        real :: x1, y1
        integer :: i, j, count, check, particle_count
    
        ! Initializations
        count = 0
        particle_count = 0
        i = 1

        !number of particle in a row
        n = int(l+1)
    
        ! Loop for RSA simulation
        do j = 1, max_count
            count = count + 1
            call random_number(x1)
            call random_number(y1)
            x(i) = nint(x1 * l)
            y(i) = nint(y1 * l)
    
            ! Call to N3_check subroutine
            call N3_check(x(i), y(i), M, check)
            
            ! Check if filling the space is possible
            if (check == 0) then
                M(x(i), y(i)) = 1
                particle_count = particle_count + 1
                density = real(particle_count) / (n)**2
                
                ! Write the information to file 2 and 1
                !write(2, '(i12, 1x, i12, 1x, f24.16)') count, particle_count, density
                !write(1, '(i12, 1x, i12)') x(i), y(i)
                i = i + 1
            else
                !write(2, '(i12, 1x, i12, 1x, f24.16)') count, particle_count, density
            end if
        end do
    
    end subroutine RSA
    
    subroutine RSAD(Matrix,particle_count,g_array,density_array)
        implicit none
        integer :: i,j,k,n,count,check,t,ii,x2,y2
        integer, intent(in) :: particle_count
        real(dp) , dimension(4) :: g
        real(dp)  :: density,x1,y1
        real(dp) ,allocatable, dimension(:), intent(inout) :: density_array
        integer(dp),allocatable,dimension(:,:), intent(in) :: Matrix
        integer(dp),allocatable,dimension(:,:) :: M
        real(dp) ,allocatable, dimension(:,:), intent(inout) ::g_array

        allocate(M(0:int(l),0:int(l)))
        g=0.0
        n = int(l+1)

        density_array(:) = 0
        g_array(:,:) = 0

        M = Matrix
        count = particle_count
        call gij(i_c,j_c,M,g)
        density=real(count)/(n)**2
        ! Time step and diffusion after almost saturate. 
        do t=1,diffu_count
            
            ! call routine for diffusion
            call random_diffuse(M)

            call random_number(x1)
            call random_number(y1)
            ! Although x(i), y(i) are not unique after diffu(M is impo) 
            x2 =  nint(x1 * l)
            y2 =  nint(y1 * l)

            call N3_check(x2,y2,M,check)
            ! Check, if possible fill 
            if (check == 0) then
                M(x2,y2) = 1
                ! call gij calculator
                call gij(i_c,j_c,M,g)
                count = count + 1
                density=real(count)/(n)**2
                g_array(t,1) = g_array(t,1) + (g(1) - density)/(1 - density)
                g_array(t,2) = g_array(t,2) + (g(2) - density)/(1 - density)
                g_array(t,3) = g_array(t,3) + (g(3) - density)/(1 - density)
                g_array(t,4) = g_array(t,4) + (g(4) - density)/(1 - density)
                density_array(t) = density_array(t) +  density
            else
                call gij(i_c,j_c,M,g)
                g_array(t,1) = g_array(t,1) + (g(1) - density)/(1 - density)
                g_array(t,2) = g_array(t,2) + (g(2) - density)/(1 - density)
                g_array(t,3) = g_array(t,3) + (g(3) - density)/(1 - density)
                g_array(t,4) = g_array(t,4) + (g(4) - density)/(1 - density)
                density_array(t) = density_array(t) +  density
            end if
        end do

        deallocate(M)
        
    end subroutine RSAD

!--------------------------------------------------------------------

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
                    if ( r1 < e) then
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
                    
                end if

            end do 
        end do



    end subroutine random_diffuse

    subroutine gij(x,y,Matrix,g)
        implicit none
        integer :: i,j,ii,jj,p_count
        integer,dimension(4),intent(in) :: x,y
        real(dp),dimension(4),intent(out) :: g
        integer(dp),allocatable,dimension(:,:), intent(inout) :: Matrix

        g=0.0
        p_count = 0
        
         
        do i = 0, int(l)
            do j = 0, int(l)
                if (Matrix(i,j) == 1) then
                    p_count = p_count + 1
                    do k = 1,4
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