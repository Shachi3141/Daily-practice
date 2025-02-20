!
! 2D RSAD 
! Aim of this code is to seperate out two types of sublattices in close pack 
! put different index with them to colour them differentyl


program Diffusion_random
    implicit none
    integer, parameter :: dp = kind(1.0d0)
    integer, parameter :: max_particles=1500    ! used in memory allocation
    integer, parameter :: max_count=1E5         ! max_count is total iteration no for RSA
    integer, parameter :: diffu_count=1E5
    real(dp),parameter :: e=0.01
    integer :: i1,j1,ii,jj,i,j,k,n,count,particle_count,check,t, part_no, part,part1,flag1,flag2
    real(dp),parameter :: l=39.0               !length of box = l
    real(dp) , dimension(4) :: g
    real(dp)  :: density,x1,y1
    integer,allocatable,dimension(:) :: x,y,xx,yy
    integer(dp),allocatable,dimension(:,:) :: M
    


    allocate(x(max_particles),y(max_particles))
    allocate(xx(0:max_particles),yy(0:max_particles))
    !number of particle in a row
    n = int(l+1)
    allocate(M(0:int(l),0:int(l)))


    M = 0
    x=0
    y=0
    print*, 'Total no of lattice site = ', (n)**2
    print*, 'Site alocation no(max_particles)= ', max_particles

    open(3,file='RSAD.txt',status='replace')
    open(4,file='RSAD_density.txt',status='replace')
    
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

    count = 0
    g = 0.0
    
    ! Time step and diffusion after almost saturate. 
    do t=1,diffu_count
        ! call routine for diffusion
        call random_diffuse(M)
        count=count+1    
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
            density=real(particle_count)/(n)**2
            write(4,'(f12.6, 1x, f24.16)') e * count, density
            i=i+1
        else
            write(4,'(f12.6, 1x, f24.16)') e * count, density
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



    open(1,file='RSAD1.txt',status='replace')
    open(2,file='RSAD2.txt',status='replace')
    open(12,file='RSAD12.txt',status='replace')
    print*, '-------------------------------->'

    print*, "Differnciate particles for colouring."

    count = 1
    do j=0, int(l)
        do k=0, int(l)
            if (M(j,k) == 1) then
                x(count) = j
                y(count) = k
                count = count + 1
            end if
        end do
    end do
    print*, "Total particle in list = ", count-1


    ! xx ,yy is list of particles coord which are alrady coloured
    
    xx(:) = int(l+5) ! all coord always ignore by below if condition unless it modified by new 
    yy(:) = int(l+5)

    i=0
    j=0
    part_no = 0
    do k=1,particle_count
        ii= x(k)
        jj= y(k)
        do part = 0, particle_count  ! cocloured particle no
            if (ii /= xx(part)  .or. jj /= yy(part) ) flag1 = 1
        end do

        if ( flag1 == 1 ) then  ! issue checkkk
            flag1 = 0
            i1 = ii + 2
            j1 = jj + 1
            call PBcolour(i1,j1)
            do part1 = 0, particle_count  ! cocloured particle no
                if (i1 /= xx(part1)  .or. j1 /= yy(part1) )  flag2 = 1
            end do

            if (flag2 == 1 ) then        ! issue checkkk
                flag2 = 0
                if (M(i1,j1) == 1) then
                    if (part_no > particle_count) stop " Exceed 1" ! Prevent infinite increment
                    write(1,*) ii,jj
                    part_no = part_no + 1
                    xx(part_no) = ii
                    yy(part_no) = jj

                    write(1,*) i1,j1
                    part_no = part_no + 1
                    xx(part_no) = i1
                    yy(part_no) = j1
                    
                    if (ii ==i .and. jj ==j ) stop "warning1---------> " ! stop if there is repetation
                    i =ii
                    j= jj
                end if
            
            end if
            
        end if

    end do

    part_no = 0
    do k=1,particle_count
        ii= x(k)
        jj= y(k)

        do part = 0, particle_count  ! cocloured particle no
            if (ii /= xx(part)  .or. jj /= yy(part) ) flag1 = 1
        end do

        if ( flag1 == 1 ) then  ! issue checkkk
            flag1 = 0
            i1 = ii + 1
            j1 = jj + 2
            call PBcolour(i1,j1)
            do part1 = 0, particle_count  ! cocloured particle no
                if (i1 /= xx(part1)  .or. j1 /= yy(part1) )  flag2 = 1
            end do

            if (flag2 == 1 ) then        ! issue checkkk
                flag2 = 0
                if (M(i1,j1) == 1) then
                    if (part_no > particle_count) stop " Exceed 2" ! Prevent infinite increment
                    write(2,*) ii,jj
                    part_no = part_no + 1
                    xx(part_no) = ii
                    yy(part_no) = jj

                    write(2,*) i1,j1
                    part_no = part_no + 1
                    xx(part_no) = i1
                    yy(part_no) = j1
                    
                    if (ii ==i .and. jj ==j ) stop "warning2---------> "! stop if there is repetation
                    i =ii
                    j= jj
                end if
            
            end if

        end if
        
    end do



    print*, "Done !!  ========= ha ha ======= "
    close(1)
    close(2)
    close(12)
    deallocate(x,y,xx,yy)
    deallocate(M)
   
    close(3)
    close(4)
    

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
                    if ( r1 < e) then
                        call random_number(r1)
                        r1 = -0.5 + (r1 * (3.5+0.5))
                        randint03 = nint(r1)

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

    subroutine PBcolour(x,y)
        implicit none
        integer,intent(inout) :: x,y
        integer :: ll

        ll = int(l+1)

        if (x > ll ) x = x - ll
        if (y > ll ) y = y - ll
        if (x < 0 ) x = x + ll
        if (y < 0 ) y = y + ll

    end subroutine PBcolour

end program Diffusion_random