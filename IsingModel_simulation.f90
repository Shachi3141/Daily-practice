! Ising model in 2D

! Incomplete   # spins are saved but succeptibliti, heat capacity, etc are not calculated.
! See: ReadMe file

program Ising
    implicit none
    integer, parameter :: L = 50  ! lattice of L x L dimension
    real(8), parameter :: JJ = 1.0 
    real(8), parameter :: k_B = 1.0
    integer, parameter :: eq_steps = 1000
    integer, parameter :: mc_steps = 1000
    real(8) :: rand_num,T,en_total
    integer, dimension(L,L) :: spins 
    integer :: i,j,flip_count

    
    open(10, file = 'Energy.txt', status = 'replace')
    open(20, file = 'Magnetization.txt', status = 'replace')
    open(30, file = 'Specficheat.txt', status = 'replace')
    open(40, file = 'Sucsceptibility.txt', status = 'replace')
    open(50, file = 'Config.txt', status = 'replace')

    flip_count = 0
    T = 0.01
    spins(:,:) = 0
    ! Initialization
    call random_seed()  ! Initialize random seed
    do i = 1,L
        do j = 1,L
            call random_number(rand_num)  
            if (rand_num < 0.5) then
                spins(i,j) = -1
            else
                spins(i,j) = 1
            end if
        end do
    end do

    !print*, 'Spins aer:'
    ! do i = 1,L
    !     write(*,'(20i3)') spins(i,:)
    ! end do
    
    ! Equlibrium 
    do i = 1, eq_steps
        call Metropolis(spins,T,flip_count)
    end do

    print*, "To equlibrum flip_count = ", flip_count
    flip_count = 0

    ! Monte Carlo steps <------------------------------------------
    do i = 1, mc_steps
        call energy(spins,en_total)
        call Metropolis(spins,T,flip_count)
        
        if ( mod(i,10) == 0) then
            do j=1,L
                write(50, '(50i5)') spins(j,:)
            end do
            write(50, *) " "
        end if
    
    end do
    

    ! print*, 'Now Spins aer:'
    ! do i = 1,L
    !     write(*,'(20i3)') spins(i,:)
    ! end do
    print*, "flip_count = ", flip_count
    ! Close the output file
    close(10)
    close(20)
    close(30)
    close(40)
    close(50)

    print *, "Done. values are saved in .txt files"


    !================================================== SUBROUTINES ======================================
    contains

    subroutine energy(spins,en_total)
        implicit none

        integer :: i,j
        integer, dimension(L,L), intent(in)  :: spins
        real(8), intent(out)  :: en_total
        real(8)  ::  en

        en_total = 0.0
        do i=1,L
            do j=1,L
                call N1_energy(i,j,spins,en)
                en_total = en_total + en 
            end do 
        end do
        en_total = en_total/2.0
    end subroutine energy

    subroutine N1_energy(x,y,spins,en)
        implicit none
        integer :: i,j,k,s,ns
        integer, dimension(4) :: dx1,dy1
        integer, intent(in) :: x,y
        integer, dimension(L,L), intent(in)  :: spins
        real(8), intent(out)  :: en

        s= spins(x,y)
        ns=0
        ! Nearest neighbor displacements (±1 along x or y)
        dx1 = (/ -1,  1,  0,  0 /)
        dy1 = (/  0,  0, -1,  1 /)
        do k = 1, 4
            i=x + dx1(k)
            j=y + dy1(k)
            call PB(i,j)
            ns = ns + spins(i,j)
        end do
        en = -JJ * s * ns
    end subroutine N1_energy


    ! Periodic boundary condition
    subroutine PB(x,y)
        implicit none
        integer,intent(inout) :: x,y
        
        if (x > L ) x = x - L
        if (y > L ) y = y - L 
        if (x < 1 ) x = x + L 
        if (y < 1 ) y = y + L 
    end subroutine PB

    subroutine Metropolis(spins,T,flip_count)
        implicit none
        integer :: i,j
        integer, intent(inout) :: flip_count
        real(8), intent(in) :: T
        integer, dimension(L,L), intent(inout)  :: spins
        real(8) :: del_e,r1,r2,r3,en

    
        call random_number(r1)
        call random_number(r2)
        i =  floor(r1 * (L+1))
        j =  floor(r2 * (L+1))

        call N1_energy(i,j,spins,en)
        del_e = - 2*en

        call random_number(r3)
        if ( r3 < exp(- del_e/(k_B*T))  .or. del_e < 0.0  ) then 
            spins(i,j) = spins(i,j) * (-1)
            flip_count = flip_count +1
        end if
    end subroutine Metropolis

end program Ising
