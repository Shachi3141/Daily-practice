program Ising
    implicit none
    integer, parameter :: L = 100  ! lattice of L x L dimension
    real(8), parameter :: JJ = 1.0 
    real(8), parameter :: k_B = 1.0
    integer, parameter :: eq_steps = 100000000
    integer, parameter :: mc_steps = 10
    real(8) :: rand_num,en_total
    integer, dimension(L,L) :: spins 
    integer :: i,j,k,flip_count,nsteps, ii
    real(8) :: T, T0, TF, dT, Energy_persite_sum, Magnet_persite_sum, Energy_persite, Magnet_persite

    
    open(10, file = 'Energy.txt', status = 'replace')
    open(20, file = 'Magnetization.txt', status = 'replace')
    open(30, file = 'Specficheat.txt', status = 'replace')
    open(40, file = 'Sucsceptibility.txt', status = 'replace')
    open(50, file = 'Config.txt', status = 'replace')

    flip_count = 0
    T0 = 0.1
    TF = 3.5
    dT = 0.05
    nsteps = int((TF - T0) / dT)
    spins(:,:) = 0


    do ii = 0, nsteps
        T = T0 + ii * dT
        
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

        ! Equlibrium 
        do i = 1, eq_steps
            call Metropolis(spins,T,flip_count)
        end do

        !print*, "To equlibrum flip_count = ", flip_count
        flip_count = 0
        ! Monte Carlo steps <------------------------------------------
        Magnet_persite_sum = 0.0
        Energy_persite_sum = 0.0
        do i = 1, mc_steps
            call energy(spins,en_total)
            call Metropolis(spins,T,flip_count)

            ! if (mod(i,1000) == 0) then
            !     do j = 1, L
            !         do k = 1, L
            !             write(50, '(3I5)') j, k, spins(j,k)
            !         end do
            !     end do
            !     write(50, *) " Next configuration "     ! Single blank line to separate frames
            ! end if
        
            Energy_persite = en_total/(L*L)
            Magnet_persite = abs(sum(spins))/real(L*L)
            Energy_persite_sum = Energy_persite_sum + Energy_persite
            Magnet_persite_sum = Magnet_persite_sum + Magnet_persite
        end do

        print*, 'Temp = ', T
        print*, ''
        write(10, '(F12.7,1x,F12.7)') T, Energy_persite_sum/mc_steps
        write(20, '(F12.7,1x,F12.7)') T, Magnet_persite_sum/mc_steps
    
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
        i = 1 + floor(r1 * L)
        j = 1 + floor(r2 * L)

        call N1_energy(i,j,spins,en)
        del_e = - 2*en

        call random_number(r3)
        if ( r3 < exp(- del_e/(k_B*T))  .or. del_e < 0.0  ) then 
            spins(i,j) = spins(i,j) * (-1)
            flip_count = flip_count +1
        end if
    end subroutine Metropolis

end program Ising
