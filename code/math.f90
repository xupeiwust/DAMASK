! Copyright 2011 Max-Planck-Institut für Eisenforschung GmbH
!
! This file is part of DAMASK,
! the Düsseldorf Advanced MAterial Simulation Kit.
!
! DAMASK is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! DAMASK is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with DAMASK. If not, see <http://www.gnu.org/licenses/>.
!
!##############################################################
!* $Id$
!##############################################################
 MODULE math   
!##############################################################


 use prec, only: pReal,pInt
 implicit none

 real(pReal), parameter :: pi = 3.14159265358979323846264338327950288419716939937510_pReal
 real(pReal), parameter :: inDeg = 180.0_pReal/pi
 real(pReal), parameter :: inRad = pi/180.0_pReal
 real(pReal), dimension(3), parameter :: NaN = & ! taken from http://ftp.aset.psu.edu/pub/ger/fortran/hdk/nan.f90
  (/B'01111111100000100000000000000000',&        ! NaN
    B'11111111100100010001001010101010',&        ! NaN
    B'11111111110000000000000000000000'/)        ! 0/0
! *** 3x3 Identity ***
 real(pReal), dimension(3,3), parameter :: math_I3 = &
 reshape( (/ &
 1.0_pReal,0.0_pReal,0.0_pReal, &
 0.0_pReal,1.0_pReal,0.0_pReal, &
 0.0_pReal,0.0_pReal,1.0_pReal /),(/3,3/))

! *** Mandel notation ***
 integer(pInt), dimension (2,6), parameter :: mapMandel = &
 reshape((/&
  1,1, &
  2,2, &
  3,3, &
  1,2, &
  2,3, &
  1,3  &
 /),(/2,6/))

 real(pReal), dimension(6), parameter :: nrmMandel = &
 (/1.0_pReal,1.0_pReal,1.0_pReal, 1.414213562373095_pReal, 1.414213562373095_pReal, 1.414213562373095_pReal/)
 real(pReal), dimension(6), parameter :: invnrmMandel = &
 (/1.0_pReal,1.0_pReal,1.0_pReal,0.7071067811865476_pReal,0.7071067811865476_pReal,0.7071067811865476_pReal/)

! *** Voigt notation ***
 integer(pInt), dimension (2,6), parameter :: mapVoigt = &
 reshape((/&
  1,1, &
  2,2, &
  3,3, &
  2,3, &
  1,3, &
  1,2  &
 /),(/2,6/))

 real(pReal), dimension(6), parameter :: nrmVoigt = &
 (/1.0_pReal,1.0_pReal,1.0_pReal, 1.0_pReal, 1.0_pReal, 1.0_pReal/)
 real(pReal), dimension(6), parameter :: invnrmVoigt = &
 (/1.0_pReal,1.0_pReal,1.0_pReal, 1.0_pReal, 1.0_pReal, 1.0_pReal/)

! *** Plain notation ***
 integer(pInt), dimension (2,9), parameter :: mapPlain = &
 reshape((/&
  1,1, &
  1,2, &
  1,3, &
  2,1, &
  2,2, &
  2,3, &
  3,1, &
  3,2, &
  3,3  &
 /),(/2,9/))

 

! Symmetry operations as quaternions
! 24 for cubic, 12 for hexagonal = 36
integer(pInt), dimension(2), parameter :: math_NsymOperations = (/24,12/)
real(pReal), dimension(4,36), parameter :: math_symOperations = &
  reshape((/&
     1.0_pReal,                 0.0_pReal,                 0.0_pReal,                 0.0_pReal, &                      ! cubic symmetry operations
     0.0_pReal,                 0.0_pReal,                 0.7071067811865476_pReal,  0.7071067811865476_pReal, &       !     2-fold symmetry
     0.0_pReal,                 0.7071067811865476_pReal,  0.0_pReal,                 0.7071067811865476_pReal, &
     0.0_pReal,                 0.7071067811865476_pReal,  0.7071067811865476_pReal,  0.0_pReal, &
     0.0_pReal,                 0.0_pReal,                 0.7071067811865476_pReal, -0.7071067811865476_pReal, &
     0.0_pReal,                -0.7071067811865476_pReal,  0.0_pReal,                 0.7071067811865476_pReal, &
     0.0_pReal,                 0.7071067811865476_pReal, -0.7071067811865476_pReal,  0.0_pReal, &
     0.5_pReal,                 0.5_pReal,                 0.5_pReal,                 0.5_pReal, &                      !     3-fold symmetry
    -0.5_pReal,                 0.5_pReal,                 0.5_pReal,                 0.5_pReal, &
     0.5_pReal,                -0.5_pReal,                 0.5_pReal,                 0.5_pReal, &
    -0.5_pReal,                -0.5_pReal,                 0.5_pReal,                 0.5_pReal, &
     0.5_pReal,                 0.5_pReal,                -0.5_pReal,                 0.5_pReal, &
    -0.5_pReal,                 0.5_pReal,                -0.5_pReal,                 0.5_pReal, &
     0.5_pReal,                 0.5_pReal,                 0.5_pReal,                -0.5_pReal, &
    -0.5_pReal,                 0.5_pReal,                 0.5_pReal,                -0.5_pReal, &
     0.7071067811865476_pReal,  0.7071067811865476_pReal,  0.0_pReal,                 0.0_pReal, &                      !     4-fold symmetry
     0.0_pReal,                 1.0_pReal,                 0.0_pReal,                 0.0_pReal, &
    -0.7071067811865476_pReal,  0.7071067811865476_pReal,  0.0_pReal,                 0.0_pReal, &
     0.7071067811865476_pReal,  0.0_pReal,                 0.7071067811865476_pReal,  0.0_pReal, &
     0.0_pReal,                 0.0_pReal,                 1.0_pReal,                 0.0_pReal, &
    -0.7071067811865476_pReal,  0.0_pReal,                 0.7071067811865476_pReal,  0.0_pReal, &
     0.7071067811865476_pReal,  0.0_pReal,                 0.0_pReal,                 0.7071067811865476_pReal, &
     0.0_pReal,                 0.0_pReal,                 0.0_pReal,                 1.0_pReal, &
    -0.7071067811865476_pReal,  0.0_pReal,                 0.0_pReal,                 0.7071067811865476_pReal, &
     1.0_pReal,                 0.0_pReal,                 0.0_pReal,                 0.0_pReal, &                      ! hexagonal symmetry operations
     0.0_pReal,                 1.0_pReal,                 0.0_pReal,                 0.0_pReal, &                      !     2-fold symmetry
     0.0_pReal,                 0.0_pReal,                 1.0_pReal,                 0.0_pReal, &
     0.0_pReal,                 0.5_pReal,                 0.866025403784439_pReal,   0.0_pReal, &
     0.0_pReal,                -0.5_pReal,                 0.866025403784439_pReal,   0.0_pReal, &
     0.0_pReal,                 0.866025403784439_pReal,   0.5_pReal,                 0.0_pReal, &
     0.0_pReal,                -0.866025403784439_pReal,   0.5_pReal,                 0.0_pReal, &
     0.866025403784439_pReal,   0.0_pReal,                 0.0_pReal,                 0.5_pReal, &                      !     6-fold symmetry
    -0.866025403784439_pReal,   0.0_pReal,                 0.0_pReal,                 0.5_pReal, &
     0.5_pReal,                 0.0_pReal,                 0.0_pReal,                 0.866025403784439_pReal, &
    -0.5_pReal,                 0.0_pReal,                 0.0_pReal,                 0.866025403784439_pReal, &
     0.0_pReal,                 0.0_pReal,                 0.0_pReal,                 1.0_pReal &
  /),(/4,36/))



 CONTAINS

!**************************************************************************
! initialization of module
!**************************************************************************
 SUBROUTINE math_init ()

 use prec,     only: pReal,pInt,tol_math_check
 use numerics, only: fixedSeed
 use IO,       only: IO_error
 use debug,    only: debug_verbosity
 implicit none

 real(pReal), dimension(3,3) :: R,R2
 real(pReal), dimension(3) ::   Eulers
 real(pReal), dimension(4) ::   q,q2,axisangle
 integer(pInt), dimension(8) :: randInit     ! gfortran requires "8" to compile
                                             ! if recalculations of former randomness (with given seed) is necessary
                                             ! set this value back to "1" and use ifort...
 
 !$OMP CRITICAL (write2out)
 write(6,*)
 write(6,*) '<<<+-  math init  -+>>>'
 write(6,*) '$Id$'
 write(6,*)
 write(6,*) 'NaN check: ',NaN/=NaN
 write(6,*)
 !$OMP END CRITICAL (write2out)
 
 if (fixedSeed > 0_pInt) then
   randInit = fixedSeed
   call random_seed(put=randInit)
 else
   call random_seed()
 endif

 call random_seed(get=randInit)
 !$OMP CRITICAL (write2out)
 ! this critical block did cause trouble at IWM
 write(6,*) 'random seed: ',randInit(1)
 write(6,*)
 !$OMP END CRITICAL (write2out)
  
 call halton_seed_set(randInit(1))
 call halton_ndim_set(3)

 ! --- check rotation dictionary ---

 ! +++ q -> a -> q  +++
 q = math_qRnd();
 axisangle = math_QuaternionToAxisAngle(q);
 q2 = math_AxisAngleToQuaternion(axisangle(1:3),axisangle(4))
 if ( any(abs( q-q2) > tol_math_check ) .and. &
      any(abs(-q-q2) > tol_math_check ) ) &
   call IO_error(670)
 
 ! +++ q -> R -> q  +++
 R = math_QuaternionToR(q);
 q2 = math_RToQuaternion(R)
 if ( any(abs( q-q2) > tol_math_check ) .and. &
      any(abs(-q-q2) > tol_math_check ) ) &
   call IO_error(671)
 
 ! +++ q -> euler -> q  +++
 Eulers = math_QuaternionToEuler(q);
 q2 = math_EulerToQuaternion(Eulers)
 if ( any(abs( q-q2) > tol_math_check ) .and. &
      any(abs(-q-q2) > tol_math_check ) ) &
   call IO_error(672)
 
 ! +++ R -> euler -> R  +++
 Eulers = math_RToEuler(R);
 R2 = math_EulerToR(Eulers)
 if ( any(abs( R-R2) > tol_math_check ) ) &
   call IO_error(673)
 
 
 ENDSUBROUTINE math_init
 


!**************************************************************************
! Quicksort algorithm for two-dimensional integer arrays
!
! Sorting is done with respect to array(1,:)
! and keeps array(2:N,:) linked to it.
!**************************************************************************
 RECURSIVE SUBROUTINE qsort(a, istart, iend)

 implicit none
 integer(pInt), dimension(:,:) :: a
 integer(pInt) :: istart,iend,ipivot

 if (istart < iend) then
   ipivot = math_partition(a,istart, iend)
   call qsort(a, istart, ipivot-1)
   call qsort(a, ipivot+1, iend)
 endif
  
 ENDSUBROUTINE qsort

!**************************************************************************
! Partitioning required for quicksort
!**************************************************************************
 integer(pInt) function math_partition(a, istart, iend)

 implicit none
 integer(pInt), dimension(:,:) :: a
 integer(pInt) :: istart,iend,d,i,j,k,x,tmp

 d = size(a,1) ! number of linked data
! set the starting and ending points, and the pivot point

 i = istart

 j = iend
 x = a(1,istart)
 do
! find the first element on the right side less than or equal to the pivot point
   do j = j, istart, -1
     if (a(1,j) <= x) exit
   enddo
! find the first element on the left side greater than the pivot point
   do i = i, iend
     if (a(1,i) > x) exit
   enddo
   if (i < j ) then ! if the indexes do not cross, exchange values
     do k = 1,d
      tmp = a(k,i)
      a(k,i) = a(k,j)
      a(k,j) = tmp
     enddo
   else           ! if they do cross, exchange left value with pivot and return with the partition index
     do k = 1,d
      tmp = a(k,istart)
      a(k,istart) = a(k,j)
      a(k,j) = tmp
     enddo
     math_partition = j
     return
   endif
 enddo

 endfunction math_partition
 

!**************************************************************************
! range of integers starting at one
!**************************************************************************
 pure function math_range(N)  

 use prec, only: pInt
 implicit none

 integer(pInt), intent(in) :: N
 integer(pInt) i
 integer(pInt), dimension(N) :: math_range

 forall (i=1:N) math_range(i) = i

 endfunction math_range

!**************************************************************************
! second rank identity tensor of specified dimension
!**************************************************************************
 pure function math_identity2nd(dimen)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt), intent(in) :: dimen
 integer(pInt)  i
 real(pReal), dimension(dimen,dimen) :: math_identity2nd

 math_identity2nd = 0.0_pReal 
 forall (i=1:dimen) math_identity2nd(i,i) = 1.0_pReal 

 endfunction math_identity2nd

!**************************************************************************
! permutation tensor e_ijk used for computing cross product of two tensors
! e_ijk =  1 if even permutation of ijk
! e_ijk = -1 if odd permutation of ijk
! e_ijk =  0 otherwise
!**************************************************************************
 pure function math_civita(i,j,k)     ! change its name from math_permut 
                                 ! to math_civita <<<updated 31.07.2009>>>

 use prec, only: pReal, pInt
 implicit none

 integer(pInt), intent(in) :: i,j,k
 real(pReal) math_civita

 math_civita = 0.0_pReal
 if (((i == 1).and.(j == 2).and.(k == 3)) .or. &
     ((i == 2).and.(j == 3).and.(k == 1)) .or. &
     ((i == 3).and.(j == 1).and.(k == 2))) math_civita = 1.0_pReal
 if (((i == 1).and.(j == 3).and.(k == 2)) .or. &
     ((i == 2).and.(j == 1).and.(k == 3)) .or. &
     ((i == 3).and.(j == 2).and.(k == 1))) math_civita = -1.0_pReal

 endfunction math_civita

!**************************************************************************
! kronecker delta function d_ij
! d_ij = 1 if i = j
! d_ij = 0 otherwise
!**************************************************************************
 pure function math_delta(i,j)

 use prec, only: pReal, pInt
 implicit none

 integer(pInt), intent (in) :: i,j
 real(pReal) math_delta

 math_delta = 0.0_pReal
 if (i == j) math_delta = 1.0_pReal

 endfunction math_delta

!**************************************************************************
! fourth rank identity tensor of specified dimension
!**************************************************************************
 pure function math_identity4th(dimen)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt), intent(in) :: dimen
 integer(pInt)  i,j,k,l
 real(pReal), dimension(dimen,dimen,dimen,dimen) ::  math_identity4th

 forall (i=1:dimen,j=1:dimen,k=1:dimen,l=1:dimen) math_identity4th(i,j,k,l) = &
        0.5_pReal*(math_I3(i,k)*math_I3(j,k)+math_I3(i,l)*math_I3(j,k)) 

 endfunction math_identity4th

 
!**************************************************************************
! vector product a x b
!**************************************************************************
 pure function math_vectorproduct(A,B)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) ::  A,B
 real(pReal), dimension(3) ::  math_vectorproduct

 math_vectorproduct(1) = A(2)*B(3)-A(3)*B(2)
 math_vectorproduct(2) = A(3)*B(1)-A(1)*B(3)
 math_vectorproduct(3) = A(1)*B(2)-A(2)*B(1)


 endfunction math_vectorproduct


!**************************************************************************
! tensor product a \otimes b
!**************************************************************************
 pure function math_tensorproduct(A,B)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) ::  A,B
 real(pReal), dimension(3,3) ::  math_tensorproduct
 integer(pInt) i,j
 
 forall (i=1:3,j=1:3) math_tensorproduct(i,j) = A(i)*B(j)


 endfunction math_tensorproduct


!**************************************************************************
! matrix multiplication 3x3 = 1
!**************************************************************************
 pure function math_mul3x3(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i
 real(pReal), dimension(3), intent(in) ::  A,B
 real(pReal), dimension(3) ::              C
 real(pReal) math_mul3x3

 forall (i=1:3) C(i) = A(i)*B(i)
 math_mul3x3 = sum(C)

 endfunction math_mul3x3


!**************************************************************************
! matrix multiplication 6x6 = 1
!**************************************************************************
 pure function math_mul6x6(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i
 real(pReal), dimension(6), intent(in) ::  A,B
 real(pReal), dimension(6) ::              C
 real(pReal) math_mul6x6

 forall (i=1:6) C(i) = A(i)*B(i)
 math_mul6x6 = sum(C)

 endfunction math_mul6x6

 
!**************************************************************************
! matrix multiplication 33x33 = 1 (double contraction --> ij * ij)
!**************************************************************************
 pure function math_mul33xx33(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i,j
 real(pReal), dimension(3,3), intent(in) ::  A,B
 real(pReal), dimension(3,3) ::              C
 real(pReal)  math_mul33xx33

 forall (i=1:3,j=1:3) C(i,j) = A(i,j) * B(i,j)
 math_mul33xx33 = sum(C)

 endfunction math_mul33xx33

!**************************************************************************
! matrix multiplication 3333x33 = 33 (double contraction --> ijkl *kl = ij)
!**************************************************************************
 pure function math_mul3333xx33(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i,j
 real(pReal), dimension(3,3,3,3), intent(in) ::  A
 real(pReal), dimension(3,3), intent(in) ::  B
 real(pReal), dimension(3,3) :: math_mul3333xx33

 do i = 1,3
   do j = 1,3
     math_mul3333xx33(i,j) = sum(A(i,j,:,:)*B(:,:))
 enddo; enddo

 endfunction math_mul3333xx33


!**************************************************************************
! matrix multiplication 33x33 = 3x3
!**************************************************************************
 pure function math_mul33x33(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i,j
 real(pReal), dimension(3,3), intent(in) ::  A,B
 real(pReal), dimension(3,3) ::  math_mul33x33

 forall (i=1:3,j=1:3) math_mul33x33(i,j) = &
   A(i,1)*B(1,j) + A(i,2)*B(2,j) + A(i,3)*B(3,j)

 endfunction math_mul33x33


!**************************************************************************
! matrix multiplication 66x66 = 6x6
!**************************************************************************
 pure function math_mul66x66(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i,j
 real(pReal), dimension(6,6), intent(in) ::  A,B
 real(pReal), dimension(6,6) ::  math_mul66x66

 forall (i=1:6,j=1:6) math_mul66x66(i,j) = &
   A(i,1)*B(1,j) + A(i,2)*B(2,j) + A(i,3)*B(3,j) + &
   A(i,4)*B(4,j) + A(i,5)*B(5,j) + A(i,6)*B(6,j)

 endfunction math_mul66x66

 
!**************************************************************************
! matrix multiplication 99x99 = 9x9
!**************************************************************************
 pure function math_mul99x99(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i,j
 real(pReal), dimension(9,9), intent(in) ::  A,B

 real(pReal), dimension(9,9) ::  math_mul99x99


 forall (i=1:9,j=1:9) math_mul99x99(i,j) = &
   A(i,1)*B(1,j) + A(i,2)*B(2,j) + A(i,3)*B(3,j) + &
   A(i,4)*B(4,j) + A(i,5)*B(5,j) + A(i,6)*B(6,j) + &
   A(i,7)*B(7,j) + A(i,8)*B(8,j) + A(i,9)*B(9,j)

 endfunction math_mul99x99

 
!**************************************************************************
! matrix multiplication 33x3 = 3
!**************************************************************************
 pure function math_mul33x3(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i
 real(pReal), dimension(3,3), intent(in) ::  A
 real(pReal), dimension(3),   intent(in) ::  B
 real(pReal), dimension(3) ::  math_mul33x3

 forall (i=1:3) math_mul33x3(i) = A(i,1)*B(1) + A(i,2)*B(2) + A(i,3)*B(3)

 endfunction math_mul33x3
 
 !**************************************************************************
! matrix multiplication complex(33) x real(3) = complex(3)
!**************************************************************************
 pure function math_mul33x3_complex(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i
 complex(pReal), dimension(3,3), intent(in) ::  A
 real(pReal),    dimension(3),   intent(in) ::  B
 complex(pReal), dimension(3) ::  math_mul33x3_complex

 forall (i=1:3) math_mul33x3_complex(i) = A(i,1)*B(1) + A(i,2)*B(2) + A(i,3)*B(3)

 endfunction math_mul33x3_complex

 
!**************************************************************************
! matrix multiplication 66x6 = 6
!**************************************************************************
 pure function math_mul66x6(A,B)  

 use prec, only: pReal, pInt
 implicit none

 integer(pInt)  i
 real(pReal), dimension(6,6), intent(in) ::  A
 real(pReal), dimension(6),   intent(in) ::  B
 real(pReal), dimension(6) ::  math_mul66x6

 forall (i=1:6) math_mul66x6(i) = &
   A(i,1)*B(1) + A(i,2)*B(2) + A(i,3)*B(3) + &
   A(i,4)*B(4) + A(i,5)*B(5) + A(i,6)*B(6)

 endfunction math_mul66x6

 
!**************************************************************************
! random quaternion
!**************************************************************************
 function math_qRnd()  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4) :: math_qRnd
 real(pReal), dimension(3) :: rnd
 
 call halton(3,rnd)
 math_qRnd(1) = cos(2.0_pReal*pi*rnd(1))*sqrt(rnd(3))
 math_qRnd(2) = sin(2.0_pReal*pi*rnd(2))*sqrt(1.0_pReal-rnd(3))
 math_qRnd(3) = cos(2.0_pReal*pi*rnd(2))*sqrt(1.0_pReal-rnd(3))
 math_qRnd(4) = sin(2.0_pReal*pi*rnd(1))*sqrt(rnd(3))

 endfunction math_qRnd

 
!**************************************************************************
! quaternion multiplication q1xq2 = q12
!**************************************************************************
 pure function math_qMul(A,B)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) ::  A, B
 real(pReal), dimension(4) ::  math_qMul

 math_qMul(1) = A(1)*B(1) - A(2)*B(2) - A(3)*B(3) - A(4)*B(4)
 math_qMul(2) = A(1)*B(2) + A(2)*B(1) + A(3)*B(4) - A(4)*B(3)
 math_qMul(3) = A(1)*B(3) - A(2)*B(4) + A(3)*B(1) + A(4)*B(2)
 math_qMul(4) = A(1)*B(4) + A(2)*B(3) - A(3)*B(2) + A(4)*B(1)

 endfunction math_qMul

 
!**************************************************************************
! quaternion dotproduct
!**************************************************************************
 pure function math_qDot(A,B)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: A, B
 real(pReal) math_qDot

 math_qDot = A(1)*B(1) + A(2)*B(2) + A(3)*B(3) + A(4)*B(4)

 endfunction math_qDot

 
!**************************************************************************
! quaternion conjugation
!**************************************************************************
 pure function math_qConj(Q)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) ::  Q
 real(pReal), dimension(4) ::  math_qConj

 math_qConj(1) = Q(1)
 math_qConj(2:4) = -Q(2:4)

 endfunction math_qConj

 
!**************************************************************************
! quaternion norm
!**************************************************************************
 pure function math_qNorm(Q)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) ::  Q
 real(pReal)  math_qNorm
 
 math_qNorm = sqrt(max(0.0_pReal, Q(1)*Q(1) + Q(2)*Q(2) + Q(3)*Q(3) + Q(4)*Q(4)))

 endfunction math_qNorm


!**************************************************************************
! quaternion inversion
!**************************************************************************
 pure function math_qInv(Q)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) ::  Q
 real(pReal), dimension(4) ::  math_qInv
 real(pReal) squareNorm
 
 math_qInv = 0.0_pReal
 
 squareNorm = math_qDot(Q,Q)
 if (squareNorm > tiny(squareNorm)) &
   math_qInv = math_qConj(Q) / squareNorm
 
 endfunction math_qInv

 
!**************************************************************************
! action of a quaternion on a vector (rotate vector v with Q)
!**************************************************************************
 pure function math_qRot(Q,v)  

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: Q
 real(pReal), dimension(3), intent(in) :: v
 real(pReal), dimension(3) :: math_qRot
 real(pReal), dimension(4,4) :: T
 integer(pInt) i, j
 
 do i = 1,4
   do j = 1,i
     T(i,j) = Q(i) * Q(j)
   enddo
 enddo
 
 math_qRot(1) = -v(1)*(T(3,3)+T(4,4)) + v(2)*(T(3,2)-T(4,1)) + v(3)*(T(4,2)+T(3,1))
 math_qRot(2) =  v(1)*(T(3,2)+T(4,1)) - v(2)*(T(2,2)+T(4,4)) + v(3)*(T(4,3)-T(2,1))
 math_qRot(3) =  v(1)*(T(4,2)-T(3,1)) + v(2)*(T(4,3)+T(2,1)) - v(3)*(T(2,2)+T(3,3))
 
 math_qRot = 2.0_pReal * math_qRot + v

 endfunction math_qRot

 
!**************************************************************************
! transposition of a 3x3 matrix
!**************************************************************************
pure function math_transpose3x3(A)

 use prec, only: pReal,pInt
 implicit none

 real(pReal),dimension(3,3),intent(in)  :: A
 real(pReal),dimension(3,3) :: math_transpose3x3
 integer(pInt) i,j
 
 forall(i=1:3, j=1:3) math_transpose3x3(i,j) = A(j,i)

 endfunction math_transpose3x3
 

!**************************************************************************
! Cramer inversion of 3x3 matrix (function)
!**************************************************************************
 pure function math_inv3x3(A)

!   direct Cramer inversion of matrix A.
!   returns all zeroes if not possible, i.e. if det close to zero

 use prec, only: pReal,pInt
 implicit none

 real(pReal),dimension(3,3),intent(in)  :: A
 real(pReal) DetA

 real(pReal),dimension(3,3) :: math_inv3x3
 
 math_inv3x3 = 0.0_pReal

 DetA =   A(1,1) * ( A(2,2) * A(3,3) - A(2,3) * A(3,2) )&
        - A(1,2) * ( A(2,1) * A(3,3) - A(2,3) * A(3,1) )&
        + A(1,3) * ( A(2,1) * A(3,2) - A(2,2) * A(3,1) )

 if (DetA > tiny(DetA)) then
   math_inv3x3(1,1) = (  A(2,2) * A(3,3) - A(2,3) * A(3,2) ) / DetA
   math_inv3x3(2,1) = ( -A(2,1) * A(3,3) + A(2,3) * A(3,1) ) / DetA
   math_inv3x3(3,1) = (  A(2,1) * A(3,2) - A(2,2) * A(3,1) ) / DetA

   math_inv3x3(1,2) = ( -A(1,2) * A(3,3) + A(1,3) * A(3,2) ) / DetA
   math_inv3x3(2,2) = (  A(1,1) * A(3,3) - A(1,3) * A(3,1) ) / DetA
   math_inv3x3(3,2) = ( -A(1,1) * A(3,2) + A(1,2) * A(3,1) ) / DetA

   math_inv3x3(1,3) = (  A(1,2) * A(2,3) - A(1,3) * A(2,2) ) / DetA
   math_inv3x3(2,3) = ( -A(1,1) * A(2,3) + A(1,3) * A(2,1) ) / DetA
   math_inv3x3(3,3) = (  A(1,1) * A(2,2) - A(1,2) * A(2,1) ) / DetA
 endif

 endfunction math_inv3x3



!**************************************************************************
! Cramer inversion of 3x3 matrix (subroutine)
!**************************************************************************
 PURE SUBROUTINE math_invert3x3(A, InvA, DetA, error)

!   Bestimmung der Determinanten und Inversen einer 3x3-Matrix
!   A      = Matrix A
!   InvA   = Inverse of A
!   DetA   = Determinant of A
!   error  = logical

 use prec, only: pReal,pInt
 implicit none

 logical, intent(out) :: error

 real(pReal),dimension(3,3),intent(in)  :: A
 real(pReal),dimension(3,3),intent(out) :: InvA
 real(pReal), intent(out) :: DetA

 DetA =   A(1,1) * ( A(2,2) * A(3,3) - A(2,3) * A(3,2) )&
        - A(1,2) * ( A(2,1) * A(3,3) - A(2,3) * A(3,1) )&
        + A(1,3) * ( A(2,1) * A(3,2) - A(2,2) * A(3,1) )

 if (DetA <= tiny(DetA)) then
   error = .true.
 else
   InvA(1,1) = (  A(2,2) * A(3,3) - A(2,3) * A(3,2) ) / DetA
   InvA(2,1) = ( -A(2,1) * A(3,3) + A(2,3) * A(3,1) ) / DetA
   InvA(3,1) = (  A(2,1) * A(3,2) - A(2,2) * A(3,1) ) / DetA

   InvA(1,2) = ( -A(1,2) * A(3,3) + A(1,3) * A(3,2) ) / DetA
   InvA(2,2) = (  A(1,1) * A(3,3) - A(1,3) * A(3,1) ) / DetA
   InvA(3,2) = ( -A(1,1) * A(3,2) + A(1,2) * A(3,1) ) / DetA

   InvA(1,3) = (  A(1,2) * A(2,3) - A(1,3) * A(2,2) ) / DetA
   InvA(2,3) = ( -A(1,1) * A(2,3) + A(1,3) * A(2,1) ) / DetA
   InvA(3,3) = (  A(1,1) * A(2,2) - A(1,2) * A(2,1) ) / DetA
   
   error = .false.
 endif

 ENDSUBROUTINE math_invert3x3



!**************************************************************************
! Gauss elimination to invert matrix of arbitrary dimension
!**************************************************************************
 PURE SUBROUTINE math_invert(dimen,A, InvA, AnzNegEW, error)

!   Invertieren einer dimen x dimen - Matrix
!   A        = Matrix A
!   InvA     = Inverse von A
!   AnzNegEW = Anzahl der negativen Eigenwerte von A
!   error    = logical
!              = false: Inversion wurde durchgefuehrt.
!              = true:  Die Inversion in SymGauss wurde wegen eines verschwindenen
!                       Pivotelement abgebrochen.

 use prec, only: pReal,pInt
 implicit none

 integer(pInt), intent(in) :: dimen
 real(pReal),dimension(dimen,dimen), intent(in)  :: A
 real(pReal),dimension(dimen,dimen), intent(out) :: InvA
 integer(pInt), intent(out) :: AnzNegEW
 logical, intent(out) :: error
 real(pReal) LogAbsDetA
 real(pReal),dimension(dimen,dimen) :: B

 InvA = math_identity2nd(dimen)
 B = A
 CALL Gauss(dimen,B,InvA,LogAbsDetA,AnzNegEW,error)

 ENDSUBROUTINE math_invert

 

! ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
! ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 PURE SUBROUTINE Gauss (dimen,A,B,LogAbsDetA,NegHDK,error)

!   Loesung eines linearen Gleichungsssystem A * X = B mit Hilfe des
!   GAUSS-Algorithmus
!   Zur numerischen Stabilisierung wird eine Zeilen- und Spaltenpivotsuche
!   durchgefuehrt.

!   Eingabeparameter:
!
!   A(dimen,dimen) = Koeffizientenmatrix A
!   B(dimen,dimen) = rechte Seiten B
!
!   Ausgabeparameter:
!
!   B(dimen,dimen)    = Matrix der Unbekanntenvektoren X
!   LogAbsDetA    = 10-Logarithmus des Betrages der Determinanten von A
!   NegHDK        = Anzahl der negativen Hauptdiagonalkoeffizienten nach der
!                   Vorwaertszerlegung
!   error         = logical
!                   = false: Das Gleichungssystem wurde geloest.
!                   = true : Matrix A ist singulaer.

!   A und B werden veraendert!

 use prec, only: pReal,pInt
 implicit none

 logical error
 integer (pInt) dimen,NegHDK
 real(pReal)    LogAbsDetA
 real(pReal)    A(dimen,dimen), B(dimen,dimen)

 INTENT (IN)     dimen
 INTENT (OUT)    LogAbsDetA, NegHDK, error
 INTENT (INOUT)  A, B

 LOGICAL        SortX
 integer (pInt) PivotZeile, PivotSpalte, StoreI, I, IP1, J, K, L
 integer (pInt) XNr(dimen)
 real(pReal)    AbsA, PivotWert, EpsAbs, Quote
 real(pReal)    StoreA(dimen), StoreB(dimen)

 error = .true.
 NegHDK = 1
 SortX  = .FALSE.

!   Unbekanntennumerierung

 DO  I = 1, dimen
    XNr(I) = I
 ENDDO

!   Genauigkeitsschranke und Bestimmung des groessten Pivotelementes

 PivotWert   = ABS(A(1,1))
 PivotZeile  = 1
 PivotSpalte = 1

 DO  I = 1, dimen
    DO  J = 1, dimen
        AbsA = ABS(A(I,J))
        IF (AbsA .GT. PivotWert) THEN
            PivotWert   = AbsA
            PivotZeile  = I
            PivotSpalte = J
        ENDIF
    ENDDO
 ENDDO

 IF (PivotWert .LT. 0.0000001) RETURN   ! Pivotelement = 0?

 EpsAbs = PivotWert * 0.1_pReal ** PRECISION(1.0_pReal)

!   V O R W A E R T S T R I A N G U L A T I O N

 DO  I = 1, dimen - 1
!     Zeilentausch?
    IF (PivotZeile .NE. I) THEN
        StoreA(I:dimen)       = A(I,I:dimen)
        A(I,I:dimen)          = A(PivotZeile,I:dimen)
        A(PivotZeile,I:dimen) = StoreA(I:dimen)
        StoreB(1:dimen)        = B(I,1:dimen)
        B(I,1:dimen)           = B(PivotZeile,1:dimen)
        B(PivotZeile,1:dimen)  = StoreB(1:dimen)
        SortX                = .TRUE.
    ENDIF
!     Spaltentausch?
    IF (PivotSpalte .NE. I) THEN
        StoreA(1:dimen)        = A(1:dimen,I)
        A(1:dimen,I)           = A(1:dimen,PivotSpalte)
        A(1:dimen,PivotSpalte) = StoreA(1:dimen)
        StoreI                = XNr(I)
        XNr(I)                = XNr(PivotSpalte)
        XNr(PivotSpalte)      = StoreI
        SortX                 = .TRUE.
    ENDIF
!     Triangulation
    DO  J = I + 1, dimen
        Quote = A(J,I) / A(I,I)
        DO  K = I + 1, dimen
            A(J,K) = A(J,K) - Quote * A(I,K)
        ENDDO
        DO  K = 1, dimen
            B(J,K) = B(J,K) - Quote * B(I,K)
        ENDDO
    ENDDO
!     Bestimmung des groessten Pivotelementes
    IP1         = I + 1
    PivotWert   = ABS(A(IP1,IP1))
    PivotZeile  = IP1
    PivotSpalte = IP1
    DO  J = IP1, dimen
        DO  K = IP1, dimen
            AbsA = ABS(A(J,K))
            IF (AbsA .GT. PivotWert) THEN
                PivotWert   = AbsA
                PivotZeile  = J
                PivotSpalte = K
            ENDIF
        ENDDO
    ENDDO

    IF (PivotWert .LT. EpsAbs) RETURN   ! Pivotelement = 0?

 ENDDO

!   R U E C K W A E R T S A U F L O E S U N G

 DO  I = dimen, 1, -1
    DO  L = 1, dimen
        DO  J = I + 1, dimen
            B(I,L) = B(I,L) - A(I,J) * B(J,L)
        ENDDO
        B(I,L) = B(I,L) / A(I,I)
    ENDDO
 ENDDO

!   Sortieren der Unbekanntenvektoren?

 IF (SortX) THEN
    DO  L = 1, dimen
        StoreA(1:dimen) = B(1:dimen,L)
        DO  I = 1, dimen
            J      = XNr(I)
            B(J,L) = StoreA(I)
        ENDDO
    ENDDO
 ENDIF

!   Determinante

 LogAbsDetA = 0.0_pReal
 NegHDK     = 0

 DO  I = 1, dimen
    IF (A(I,I) .LT. 0.0_pReal) NegHDK = NegHDK + 1
    AbsA       = ABS(A(I,I))
    LogAbsDetA = LogAbsDetA + LOG10(AbsA)
 ENDDO

 error = .false.

 ENDSUBROUTINE Gauss



!********************************************************************
! symmetrize a 3x3 matrix
!********************************************************************
 function math_symmetric3x3(m)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3) :: math_symmetric3x3,m
 integer(pInt) i,j
 
 forall (i=1:3,j=1:3) math_symmetric3x3(i,j) = 0.5_pReal * (m(i,j) + m(j,i))

 endfunction math_symmetric3x3
 

!********************************************************************
! symmetrize a 6x6 matrix
!********************************************************************
 pure function math_symmetric6x6(m)

 use prec, only: pReal,pInt
 implicit none

 integer(pInt) i,j
 real(pReal), dimension(6,6), intent(in) :: m
 real(pReal), dimension(6,6) :: math_symmetric6x6
 
 forall (i=1:6,j=1:6) math_symmetric6x6(i,j) = 0.5_pReal * (m(i,j) + m(j,i))

 endfunction math_symmetric6x6
 

!********************************************************************
! equivalent scalar quantity of a full strain tensor
!********************************************************************
 pure function math_equivStrain33(m)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3), intent(in) :: m
 real(pReal) math_equivStrain33,e11,e22,e33,s12,s23,s31

 e11 = (2.0_pReal*m(1,1)-m(2,2)-m(3,3))/3.0_pReal
 e22 = (2.0_pReal*m(2,2)-m(3,3)-m(1,1))/3.0_pReal
 e33 = (2.0_pReal*m(3,3)-m(1,1)-m(2,2))/3.0_pReal
 s12 = 2.0_pReal*m(1,2)
 s23 = 2.0_pReal*m(2,3)
 s31 = 2.0_pReal*m(3,1)

 math_equivStrain33 = 2.0_pReal*(1.50_pReal*(e11**2.0_pReal+e22**2.0_pReal+e33**2.0_pReal) + &
                                 0.75_pReal*(s12**2.0_pReal+s23**2.0_pReal+s31**2.0_pReal))**(0.5_pReal)/3.0_pReal

 endfunction math_equivStrain33


!********************************************************************
! determinant of a 3x3 matrix
!********************************************************************
 pure function math_det3x3(m)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3), intent(in) :: m
 real(pReal) math_det3x3

 math_det3x3 = m(1,1)*(m(2,2)*m(3,3)-m(2,3)*m(3,2)) &
              -m(1,2)*(m(2,1)*m(3,3)-m(2,3)*m(3,1)) &
              +m(1,3)*(m(2,1)*m(3,2)-m(2,2)*m(3,1))

 endfunction math_det3x3

 
!********************************************************************
! norm of a 3x3 matrix
!********************************************************************
 pure function math_norm33(m)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3), intent(in) :: m
 real(pReal) math_norm33

 math_norm33 = sqrt(sum(m**2.0_pReal))

 endfunction

 
!********************************************************************
! euclidic norm of a 3x1 vector
!********************************************************************
 pure function math_norm3(v)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: v
 real(pReal) math_norm3

 math_norm3 = sqrt(v(1)*v(1) + v(2)*v(2) + v(3)*v(3))
 
 endfunction math_norm3

 
!********************************************************************
! convert 3x3 matrix into vector 9x1
!********************************************************************
 pure function math_Plain33to9(m33)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3), intent(in) :: m33
 real(pReal), dimension(9) :: math_Plain33to9
 integer(pInt) i
 
 forall (i=1:9) math_Plain33to9(i) = m33(mapPlain(1,i),mapPlain(2,i))

 endfunction math_Plain33to9
 
 
!********************************************************************
! convert Plain 9x1 back to 3x3 matrix
!********************************************************************
 pure function math_Plain9to33(v9)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(9), intent(in) :: v9
 real(pReal), dimension(3,3) :: math_Plain9to33
 integer(pInt) i
 
 forall (i=1:9) math_Plain9to33(mapPlain(1,i),mapPlain(2,i)) = v9(i)

 endfunction math_Plain9to33
 

!********************************************************************
! convert symmetric 3x3 matrix into Mandel vector 6x1
!********************************************************************
 pure function math_Mandel33to6(m33)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3), intent(in) :: m33
 real(pReal), dimension(6) :: math_Mandel33to6
 integer(pInt) i
 
 forall (i=1:6) math_Mandel33to6(i) = nrmMandel(i)*m33(mapMandel(1,i),mapMandel(2,i))

 endfunction math_Mandel33to6


!********************************************************************
! convert Mandel 6x1 back to symmetric 3x3 matrix
!********************************************************************
 pure function math_Mandel6to33(v6)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(6), intent(in) :: v6
 real(pReal), dimension(3,3) :: math_Mandel6to33
 integer(pInt) i
 
 forall (i=1:6)
  math_Mandel6to33(mapMandel(1,i),mapMandel(2,i)) = invnrmMandel(i)*v6(i)
  math_Mandel6to33(mapMandel(2,i),mapMandel(1,i)) = invnrmMandel(i)*v6(i)
 end forall

 endfunction math_Mandel6to33


!********************************************************************
! convert 3x3x3x3 tensor into plain matrix 9x9
!********************************************************************
 pure function math_Plain3333to99(m3333)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3,3,3), intent(in) :: m3333
 real(pReal), dimension(9,9) :: math_Plain3333to99
 integer(pInt) i,j
 
 forall (i=1:9,j=1:9) math_Plain3333to99(i,j) = &
   m3333(mapPlain(1,i),mapPlain(2,i),mapPlain(1,j),mapPlain(2,j))

 endfunction math_Plain3333to99
 
!********************************************************************
! plain matrix 9x9 into 3x3x3x3 tensor
!********************************************************************
 pure function math_Plain99to3333(m99)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(9,9), intent(in) :: m99
 real(pReal), dimension(3,3,3,3) :: math_Plain99to3333
 integer(pInt) i,j
 
 forall (i=1:9,j=1:9) math_Plain99to3333(mapPlain(1,i),mapPlain(2,i),&
     mapPlain(1,j),mapPlain(2,j)) = m99(i,j)

 endfunction math_Plain99to3333


!********************************************************************
! convert Mandel matrix 6x6 into Plain matrix 6x6
!********************************************************************
 pure function math_Mandel66toPlain66(m66)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(6,6), intent(in) :: m66
 real(pReal), dimension(6,6) :: math_Mandel66toPlain66
 integer(pInt) i,j
 
 forall (i=1:6,j=1:6) &
   math_Mandel66toPlain66(i,j) = invnrmMandel(i) * invnrmMandel(j) * m66(i,j)
 return

 endfunction



!********************************************************************
! convert Plain matrix 6x6 into Mandel matrix 6x6
!********************************************************************
 pure function math_Plain66toMandel66(m66)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(6,6), intent(in) :: m66
 real(pReal), dimension(6,6) :: math_Plain66toMandel66
 integer(pInt) i,j
 
 forall (i=1:6,j=1:6) &
   math_Plain66toMandel66(i,j) = nrmMandel(i) * nrmMandel(j) * m66(i,j)
 return

 endfunction



!********************************************************************
! convert symmetric 3x3x3x3 tensor into Mandel matrix 6x6
!********************************************************************
 pure function math_Mandel3333to66(m3333)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(3,3,3,3), intent(in) :: m3333
 real(pReal), dimension(6,6) :: math_Mandel3333to66
 integer(pInt) i,j
 
 forall (i=1:6,j=1:6) math_Mandel3333to66(i,j) = &
   nrmMandel(i)*nrmMandel(j)*m3333(mapMandel(1,i),mapMandel(2,i),mapMandel(1,j),mapMandel(2,j))

 endfunction math_Mandel3333to66

!********************************************************************
! convert Mandel matrix 6x6 back to symmetric 3x3x3x3 tensor
!********************************************************************
 pure function math_Mandel66to3333(m66)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(6,6), intent(in) :: m66
 real(pReal), dimension(3,3,3,3) :: math_Mandel66to3333
 integer(pInt) i,j
 
 forall (i=1:6,j=1:6) 
   math_Mandel66to3333(mapMandel(1,i),mapMandel(2,i),mapMandel(1,j),mapMandel(2,j)) = invnrmMandel(i)*invnrmMandel(j)*m66(i,j)
   math_Mandel66to3333(mapMandel(2,i),mapMandel(1,i),mapMandel(1,j),mapMandel(2,j)) = invnrmMandel(i)*invnrmMandel(j)*m66(i,j)
   math_Mandel66to3333(mapMandel(1,i),mapMandel(2,i),mapMandel(2,j),mapMandel(1,j)) = invnrmMandel(i)*invnrmMandel(j)*m66(i,j)
   math_Mandel66to3333(mapMandel(2,i),mapMandel(1,i),mapMandel(2,j),mapMandel(1,j)) = invnrmMandel(i)*invnrmMandel(j)*m66(i,j)
 end forall

 endfunction math_Mandel66to3333



!********************************************************************
! convert Voigt matrix 6x6 back to symmetric 3x3x3x3 tensor
!********************************************************************
 pure function math_Voigt66to3333(m66)

 use prec, only: pReal,pInt
 implicit none

 real(pReal), dimension(6,6), intent(in) :: m66
 real(pReal), dimension(3,3,3,3) :: math_Voigt66to3333
 integer(pInt) i,j
 
 forall (i=1:6,j=1:6) 
   math_Voigt66to3333(mapVoigt(1,i),mapVoigt(2,i),mapVoigt(1,j),mapVoigt(2,j)) = invnrmVoigt(i)*invnrmVoigt(j)*m66(i,j)
   math_Voigt66to3333(mapVoigt(2,i),mapVoigt(1,i),mapVoigt(1,j),mapVoigt(2,j)) = invnrmVoigt(i)*invnrmVoigt(j)*m66(i,j)
   math_Voigt66to3333(mapVoigt(1,i),mapVoigt(2,i),mapVoigt(2,j),mapVoigt(1,j)) = invnrmVoigt(i)*invnrmVoigt(j)*m66(i,j)
   math_Voigt66to3333(mapVoigt(2,i),mapVoigt(1,i),mapVoigt(2,j),mapVoigt(1,j)) = invnrmVoigt(i)*invnrmVoigt(j)*m66(i,j)
 end forall

 endfunction math_Voigt66to3333



!********************************************************************
! Euler angles (in radians) from rotation matrix
!********************************************************************
 pure function math_RtoEuler(R)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension (3,3), intent(in) :: R
 real(pReal), dimension(3) :: math_RtoEuler
 real(pReal) sqhkl, squvw, sqhk, val

 sqhkl=sqrt(R(1,3)*R(1,3)+R(2,3)*R(2,3)+R(3,3)*R(3,3))
 squvw=sqrt(R(1,1)*R(1,1)+R(2,1)*R(2,1)+R(3,1)*R(3,1))
 sqhk=sqrt(R(1,3)*R(1,3)+R(2,3)*R(2,3))
! calculate PHI
 val=R(3,3)/sqhkl
 
 if(val >  1.0_pReal) val =  1.0_pReal
 if(val < -1.0_pReal) val = -1.0_pReal
     
 math_RtoEuler(2) = acos(val)

 if(math_RtoEuler(2) < 1.0e-8_pReal) then
! calculate phi2
     math_RtoEuler(3) = 0.0_pReal
! calculate phi1
     val=R(1,1)/squvw
     if(val >  1.0_pReal) val =  1.0_pReal
     if(val < -1.0_pReal) val = -1.0_pReal
     
     math_RtoEuler(1) = acos(val)
     if(R(2,1) > 0.0_pReal) math_RtoEuler(1) = 2.0_pReal*pi-math_RtoEuler(1)
 else
! calculate phi2
     val=R(2,3)/sqhk
     if(val >  1.0_pReal) val =  1.0_pReal
     if(val < -1.0_pReal) val = -1.0_pReal
     
     math_RtoEuler(3) = acos(val)
     if(R(1,3) < 0.0) math_RtoEuler(3) = 2.0_pReal*pi-math_RtoEuler(3)
! calculate phi1
     val=-R(3,2)/sin(math_RtoEuler(2))
     if(val >  1.0_pReal) val =  1.0_pReal
     if(val < -1.0_pReal) val = -1.0_pReal
     
     math_RtoEuler(1) = acos(val)
     if(R(3,1) < 0.0) math_RtoEuler(1) = 2.0_pReal*pi-math_RtoEuler(1)
 end if
 
 endfunction math_RtoEuler


!********************************************************************
! quaternion (w+ix+jy+kz) from orientation matrix
!********************************************************************
 pure function math_RtoQuaternion(R)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension (3,3), intent(in) :: R
 real(pReal), dimension(4)   :: absQ,math_RtoQuaternion
 real(pReal) max_absQ
 integer(pInt), dimension(1) :: largest
 
 ! math adopted from http://code.google.com/p/mtex/source/browse/trunk/geometry/geometry_tools/mat2quat.m

 math_RtoQuaternion = 0.0_pReal

 absQ(1) = 1.0_pReal+R(1,1)+R(2,2)+R(3,3)
 absQ(2) = 1.0_pReal+R(1,1)-R(2,2)-R(3,3)
 absQ(3) = 1.0_pReal-R(1,1)+R(2,2)-R(3,3)
 absQ(4) = 1.0_pReal-R(1,1)-R(2,2)+R(3,3)

 largest = maxloc(absQ)

 max_absQ=0.5_pReal * sqrt(absQ(largest(1))) 

 select case(largest(1))
   case (1)

      math_RtoQuaternion(2) = R(2,3)-R(3,2)
      math_RtoQuaternion(3) = R(3,1)-R(1,3)
      math_RtoQuaternion(4) = R(1,2)-R(2,1)
   
   case (2)
      math_RtoQuaternion(1) = R(2,3)-R(3,2)

      math_RtoQuaternion(3) = R(1,2)+R(2,1)
      math_RtoQuaternion(4) = R(3,1)+R(1,3)
   
   case (3)
      math_RtoQuaternion(1) = R(3,1)-R(1,3)
      math_RtoQuaternion(2) = R(1,2)+R(2,1)

      math_RtoQuaternion(4) = R(2,3)+R(3,2)
   
   case (4)
      math_RtoQuaternion (1) = R(1,2)-R(2,1)
      math_RtoQuaternion (2) = R(3,1)+R(1,3)
      math_RtoQuaternion (3) = R(3,2)+R(2,3)
 
 end select

 math_RtoQuaternion = math_RtoQuaternion*0.25_pReal/max_absQ
 math_RtoQuaternion(largest(1)) = max_absQ
 
 endfunction math_RtoQuaternion


!****************************************************************
! rotation matrix from Euler angles (in radians)
!****************************************************************
 pure function math_EulerToR(Euler)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: Euler
 real(pReal), dimension(3,3) :: math_EulerToR
 real(pReal) c1, c, c2, s1, s, s2

 C1 = cos(Euler(1))
 C = cos(Euler(2))
 C2 = cos(Euler(3))
 S1 = sin(Euler(1))
 S = sin(Euler(2))
 S2 = sin(Euler(3))
 math_EulerToR(1,1)=C1*C2-S1*S2*C
 math_EulerToR(1,2)=S1*C2+C1*S2*C
 math_EulerToR(1,3)=S2*S
 math_EulerToR(2,1)=-C1*S2-S1*C2*C
 math_EulerToR(2,2)=-S1*S2+C1*C2*C
 math_EulerToR(2,3)=C2*S
 math_EulerToR(3,1)=S1*S
 math_EulerToR(3,2)=-C1*S
 math_EulerToR(3,3)=C
 
 endfunction math_EulerToR


!********************************************************************
! quaternion (w+ix+jy+kz) from 3-1-3 Euler angles (in radians)
!********************************************************************
 pure function math_EulerToQuaternion(eulerangles)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: eulerangles
 real(pReal), dimension(4) :: math_EulerToQuaternion
 real(pReal), dimension(3) :: halfangles
 real(pReal) c, s
 
 halfangles = 0.5_pReal * eulerangles
 
 c = cos(halfangles(2))
 s = sin(halfangles(2))
 
 math_EulerToQuaternion(1) = cos(halfangles(1)+halfangles(3)) * c
 math_EulerToQuaternion(2) = cos(halfangles(1)-halfangles(3)) * s
 math_EulerToQuaternion(3) = sin(halfangles(1)-halfangles(3)) * s
 math_EulerToQuaternion(4) = sin(halfangles(1)+halfangles(3)) * c
  
 endfunction math_EulerToQuaternion


!****************************************************************
! rotation matrix from axis and angle (in radians)  
!****************************************************************
 pure function math_AxisAngleToR(axis,omega)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: axis
 real(pReal), intent(in) :: omega
 real(pReal), dimension(3) :: axisNrm
 real(pReal), dimension(3,3) :: math_AxisAngleToR
 real(pReal) norm,s,c,c1
 integer(pInt) i

 norm = sqrt(math_mul3x3(axis,axis))
 if (norm > 1.0e-8_pReal) then                       ! non-zero rotation
   forall (i=1:3) axisNrm(i) = axis(i)/norm          ! normalize axis to be sure

   s = sin(omega)
   c = cos(omega)
   c1 = 1.0_pReal - c
  
   ! formula for active rotation taken from http://mathworld.wolfram.com/RodriguesRotationFormula.html
   ! below is transposed form to get passive rotation
  
   math_AxisAngleToR(1,1) = c + c1*axisNrm(1)**2
   math_AxisAngleToR(2,1) = -s*axisNrm(3) + c1*axisNrm(1)*axisNrm(2) 
   math_AxisAngleToR(3,1) =  s*axisNrm(2) + c1*axisNrm(1)*axisNrm(3)
  
   math_AxisAngleToR(1,2) =  s*axisNrm(3) + c1*axisNrm(2)*axisNrm(1)
   math_AxisAngleToR(2,2) = c + c1*axisNrm(2)**2
   math_AxisAngleToR(3,2) = -s*axisNrm(1) + c1*axisNrm(2)*axisNrm(3)
  
   math_AxisAngleToR(1,3) = -s*axisNrm(2) + c1*axisNrm(3)*axisNrm(1)
   math_AxisAngleToR(2,3) =  s*axisNrm(1) + c1*axisNrm(3)*axisNrm(2)
   math_AxisAngleToR(3,3) = c + c1*axisNrm(3)**2
 else
   math_AxisAngleToR = math_I3
 endif
 

 endfunction math_AxisAngleToR


!****************************************************************
! quaternion (w+ix+jy+kz) from axis and angle (in radians)  
!****************************************************************
 pure function math_AxisAngleToQuaternion(axis,omega)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: axis
 real(pReal), intent(in) :: omega
 real(pReal), dimension(3) :: axisNrm
 real(pReal), dimension(4) :: math_AxisAngleToQuaternion
 real(pReal) s,c,norm
 integer(pInt) i

 norm = sqrt(math_mul3x3(axis,axis))
 if (norm > 1.0e-8_pReal) then                       ! non-zero rotation
   forall (i=1:3) axisNrm(i) = axis(i)/norm          ! normalize axis to be sure
   ! formula taken from http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29#Rodrigues_parameters
   s = sin(omega/2.0_pReal)
   c = cos(omega/2.0_pReal)
   math_AxisAngleToQuaternion(1) =   c
   math_AxisAngleToQuaternion(2:4) = s * axisNrm(1:3)
 else
   math_AxisAngleToQuaternion = (/1.0_pReal,0.0_pReal,0.0_pReal,0.0_pReal/)   ! no rotation
 endif


 endfunction math_AxisAngleToQuaternion


!********************************************************************
! orientation matrix from quaternion (w+ix+jy+kz)
!********************************************************************
 pure function math_QuaternionToR(Q)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: Q
 real(pReal), dimension(3,3) :: math_QuaternionToR, T,S
 integer(pInt) i, j
 
 forall (i = 1:3, j = 1:3) &
   T(i,j) = Q(i+1) * Q(j+1)
 S = reshape( (/0.0_pReal,     Q(4),    -Q(3), &
                    -Q(4),0.0_pReal,    +Q(2), &
                     Q(3),    -Q(2),0.0_pReal/),(/3,3/))  ! notation is transposed!

 math_QuaternionToR = (2.0_pReal * Q(1)*Q(1) - 1.0_pReal) * math_I3 + &
                      2.0_pReal * T - &
                      2.0_pReal * Q(1) * S
 
 
 endfunction math_QuaternionToR


!********************************************************************
! 3-1-3 Euler angles (in radians) from quaternion (w+ix+jy+kz)
!********************************************************************
 pure function math_QuaternionToEuler(Q)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: Q
 real(pReal), dimension(3) :: math_QuaternionToEuler
 real(pReal) acos_arg

 math_QuaternionToEuler(2) = acos(1.0_pReal-2.0_pReal*(Q(2)*Q(2)+Q(3)*Q(3)))

 if (abs(math_QuaternionToEuler(2)) < 1.0e-3_pReal) then
   acos_arg=Q(1)
   if(acos_arg > 1.0_pReal)acos_arg = 1.0_pReal 
   if(acos_arg < -1.0_pReal)acos_arg = -1.0_pReal 
   math_QuaternionToEuler(1) = 2.0_pReal*acos(acos_arg)
   math_QuaternionToEuler(3) = 0.0_pReal
 else
   math_QuaternionToEuler(1) = atan2(Q(1)*Q(3)+Q(2)*Q(4), Q(1)*Q(2)-Q(3)*Q(4))
   if (math_QuaternionToEuler(1) < 0.0_pReal) &
     math_QuaternionToEuler(1) = math_QuaternionToEuler(1) + 2.0_pReal * pi

   math_QuaternionToEuler(3) = atan2(-Q(1)*Q(3)+Q(2)*Q(4), Q(1)*Q(2)+Q(3)*Q(4))
   if (math_QuaternionToEuler(3) < 0.0_pReal) &
     math_QuaternionToEuler(3) = math_QuaternionToEuler(3) + 2.0_pReal * pi
 endif

 if (math_QuaternionToEuler(2) < 0.0_pReal) &
   math_QuaternionToEuler(2) = math_QuaternionToEuler(2) + pi

 endfunction math_QuaternionToEuler


!********************************************************************
! axis-angle (x, y, z, ang in radians) from quaternion (w+ix+jy+kz)
!********************************************************************
 pure function math_QuaternionToAxisAngle(Q)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: Q
 real(pReal) halfAngle, sinHalfAngle
 real(pReal), dimension(4) :: math_QuaternionToAxisAngle  

 halfAngle = acos(max(-1.0_pReal, min(1.0_pReal, Q(1))))            ! limit to [-1,1] --> 0 to 180 deg
 sinHalfAngle = sin(halfAngle)
 
 if (sinHalfAngle <= 1.0e-4_pReal) then                              ! very small rotation angle?
   math_QuaternionToAxisAngle = 0.0_pReal
 else
   math_QuaternionToAxisAngle(1:3) = Q(2:4)/sinHalfAngle
   math_QuaternionToAxisAngle(4) = halfAngle*2.0_pReal
 endif

 
 endfunction math_QuaternionToAxisAngle


!********************************************************************
! Rodrigues vector (x, y, z) from unit quaternion (w+ix+jy+kz)
!********************************************************************
 pure function math_QuaternionToRodrig(Q)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(4), intent(in) :: Q
 real(pReal), dimension(3) :: math_QuaternionToRodrig

 if (Q(1) /= 0.0_pReal) then                                   ! unless rotation by 180 deg
   math_QuaternionToRodrig = Q(2:4)/Q(1)
 else
   math_QuaternionToRodrig = NaN(3)                            ! 0/0, since Rodrig is unbound for 180 deg...
 endif


 endfunction math_QuaternionToRodrig


!**************************************************************************
! misorientation angle between two sets of Euler angles
!**************************************************************************
 pure function math_EulerMisorientation(EulerA,EulerB)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3), intent(in) :: EulerA,EulerB
 real(pReal), dimension(3,3) :: r
 real(pReal) math_EulerMisorientation, tr

 r = math_mul33x33(math_EulerToR(EulerB),transpose(math_EulerToR(EulerA)))

 tr = (r(1,1)+r(2,2)+r(3,3)-1.0_pReal)*0.4999999_pReal
 math_EulerMisorientation = abs(0.5_pReal*pi-asin(tr))

 endfunction math_EulerMisorientation


!**************************************************************************
! figures whether unit quat falls into stereographic standard triangle
!**************************************************************************
pure function math_QuaternionInSST(Q, symmetryType)

  use prec, only: pReal, pInt
  implicit none

  !*** input variables 
  real(pReal), dimension(4), intent(in) ::      Q                           ! orientation
  integer(pInt), intent(in) ::                  symmetryType                ! Type of crystal symmetry; 1:cubic, 2:hexagonal

  !*** output variables
  logical                                       math_QuaternionInSST
  
  !*** local variables
  real(pReal), dimension(3) ::                  Rodrig                      ! Rodrigues vector of Q
 
  Rodrig = math_QuaternionToRodrig(Q)
  select case (symmetryType)
    case (1)
      math_QuaternionInSST = Rodrig(1) > Rodrig(2) .and. &
                             Rodrig(2) > Rodrig(3) .and. &
                             Rodrig(3) > 0.0_pReal
    case (2)
      math_QuaternionInSST = Rodrig(1) > sqrt(3.0_pReal)*Rodrig(2) .and. &
                             Rodrig(2) > 0.0_pReal .and. &
                             Rodrig(3) > 0.0_pReal
    case default
      math_QuaternionInSST = .true.
  end select
  
endfunction math_QuaternionInSST


!**************************************************************************
! calculates the disorientation for 2 unit quaternions
!**************************************************************************
function math_QuaternionDisorientation(Q1, Q2, symmetryType)

  use prec, only: pReal, pInt
  use IO,   only: IO_error
  implicit none
  
  !*** input variables 
  real(pReal), dimension(4), intent(in) ::      Q1, &                       ! 1st orientation
                                                Q2                          ! 2nd orientation
  integer(pInt), intent(in) ::                  symmetryType                ! Type of crystal symmetry; 1:cubic, 2:hexagonal
  
  !*** output variables
  real(pReal), dimension(4) ::                  math_QuaternionDisorientation         ! disorientation
  
  !*** local variables
  real(pReal), dimension(4) ::                  dQ,dQsymA,mis
  integer(pInt)                                 i,j,k,s
  
  dQ = math_qMul(math_qConj(Q1),Q2)
  math_QuaternionDisorientation = dQ
    
  select case (symmetryType)
    case (0)
      if (math_QuaternionDisorientation(1) < 0.0_pReal) &
        math_QuaternionDisorientation = -math_QuaternionDisorientation          ! keep omega within 0 to 180 deg
    
    case (1,2)
      s = sum(math_NsymOperations(1:symmetryType-1))
      do i = 1,2
        dQ = math_qConj(dQ)                                     ! switch order of "from -- to"
        do j = 1,math_NsymOperations(symmetryType)              ! run through first crystal's symmetries
          dQsymA = math_qMul(math_symOperations(:,s+j),dQ)      ! apply sym
          do k = 1,math_NsymOperations(symmetryType)            ! run through 2nd crystal's symmetries
            mis = math_qMul(dQsymA,math_symOperations(:,s+k))   ! apply sym
            if (mis(1) < 0.0_pReal) &                           ! want positive angle
              mis = -mis
            if (mis(1)-math_QuaternionDisorientation(1) > -1e-8_pReal .and. &
                math_QuaternionInSST(mis,symmetryType)) &
              math_QuaternionDisorientation = mis               ! found better one
      enddo; enddo; enddo
  
    case default
      call IO_error(550,symmetryType)                           ! complain about unknown symmetry
  end select
  
endfunction math_QuaternionDisorientation


!********************************************************************
!   draw a random sample from Euler space
!********************************************************************
 function math_sampleRandomOri()

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3) :: math_sampleRandomOri, rnd

 call halton(3,rnd)
 math_sampleRandomOri(1) = rnd(1)*2.0_pReal*pi
 math_sampleRandomOri(2) = acos(2.0_pReal*rnd(2)-1.0_pReal)
 math_sampleRandomOri(3) = rnd(3)*2.0_pReal*pi

 endfunction math_sampleRandomOri


!********************************************************************
!   draw a random sample from Gauss component
!   with noise (in radians) half-width 
!********************************************************************
 function math_sampleGaussOri(center,noise)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3) :: math_sampleGaussOri, center, disturb
 real(pReal), dimension(3), parameter :: origin = (/0.0_pReal,0.0_pReal,0.0_pReal/)
 real(pReal), dimension(5) :: rnd
 real(pReal) noise,scatter,cosScatter
 integer(pInt) i

if (noise==0.0) then
    math_sampleGaussOri = center
    return
endif

! Helming uses different distribution with Bessel functions
! therefore the gauss scatter width has to be scaled differently
 scatter = 0.95_pReal * noise
 cosScatter = cos(scatter)

 do
   call halton(5,rnd)
   forall (i=1:3) rnd(i) = 2.0_pReal*rnd(i)-1.0_pReal  ! expand 1:3 to range [-1,+1] 
   disturb(1) = scatter * rnd(1)                                                      ! phi1
   disturb(2) = sign(1.0_pReal,rnd(2))*acos(cosScatter+(1.0_pReal-cosScatter)*rnd(4)) ! Phi
   disturb(3) = scatter * rnd(2)                                                      ! phi2
   if (rnd(5) <= exp(-1.0_pReal*(math_EulerMisorientation(origin,disturb)/scatter)**2)) exit   
 enddo

 math_sampleGaussOri = math_RtoEuler(math_mul33x33(math_EulerToR(disturb),math_EulerToR(center)))
 
 endfunction math_sampleGaussOri
 

!********************************************************************
!   draw a random sample from Fiber component
!   with noise (in radians)
!********************************************************************
 function math_sampleFiberOri(alpha,beta,noise)

 use prec, only: pReal, pInt
 implicit none

 real(pReal), dimension(3) :: math_sampleFiberOri, fiberInC,fiberInS,axis
 real(pReal), dimension(2) :: alpha,beta, rnd
 real(pReal), dimension(3,3) :: oRot,fRot,pRot
 real(pReal) noise, scatter, cos2Scatter, angle
 integer(pInt), dimension(2,3), parameter :: rotMap = reshape((/2,3, 3,1, 1,2/),(/2,3/))
 integer(pInt) i

! Helming uses different distribution with Bessel functions
! therefore the gauss scatter width has to be scaled differently
 scatter = 0.95_pReal * noise
 cos2Scatter = cos(2.0_pReal*scatter)

! fiber axis in crystal coordinate system
 fiberInC(1)=sin(alpha(1))*cos(alpha(2))
 fiberInC(2)=sin(alpha(1))*sin(alpha(2))
 fiberInC(3)=cos(alpha(1))
! fiber axis in sample coordinate system
 fiberInS(1)=sin(beta(1))*cos(beta(2))
 fiberInS(2)=sin(beta(1))*sin(beta(2))
 fiberInS(3)=cos(beta(1))

! ---# rotation matrix from sample to crystal system #---
 angle = -acos(dot_product(fiberInC,fiberInS))
 if(angle /= 0.0_pReal) then
!   rotation axis between sample and crystal system (cross product)
   forall(i=1:3) axis(i) = fiberInC(rotMap(1,i))*fiberInS(rotMap(2,i))-fiberInC(rotMap(2,i))*fiberInS(rotMap(1,i))
   oRot = math_AxisAngleToR(math_vectorproduct(fiberInC,fiberInS),angle)
 else
   oRot = math_I3
 end if

! ---# rotation matrix about fiber axis (random angle) #---
 call halton(1,rnd)
 fRot = math_AxisAngleToR(fiberInS,rnd(1)*2.0_pReal*pi)

! ---# rotation about random axis perpend to fiber #---
! random axis pependicular to fiber axis 
 call halton(2,axis)
 if (fiberInS(3) /= 0.0_pReal) then
     axis(3)=-(axis(1)*fiberInS(1)+axis(2)*fiberInS(2))/fiberInS(3)
 else if(fiberInS(2) /= 0.0_pReal) then
     axis(3)=axis(2)
     axis(2)=-(axis(1)*fiberInS(1)+axis(3)*fiberInS(3))/fiberInS(2)
 else if(fiberInS(1) /= 0.0_pReal) then
     axis(3)=axis(1)
     axis(1)=-(axis(2)*fiberInS(2)+axis(3)*fiberInS(3))/fiberInS(1)
 end if

! scattered rotation angle 
 do
   call halton(2,rnd)
     angle = acos(cos2Scatter+(1.0_pReal-cos2Scatter)*rnd(1))
     if (rnd(2) <= exp(-1.0_pReal*(angle/scatter)**2)) exit
 enddo
 call halton(1,rnd)
 if (rnd(1) <= 0.5) angle = -angle
 pRot = math_AxisAngleToR(axis,angle)

! ---# apply the three rotations #---
 math_sampleFiberOri = math_RtoEuler(math_mul33x33(pRot,math_mul33x33(fRot,oRot))) 

 endfunction math_sampleFiberOri



!********************************************************************
!   symmetric Euler angles for given symmetry string
!   'triclinic' or '', 'monoclinic', 'orthotropic'
!********************************************************************
 pure function math_symmetricEulers(sym,Euler)

 use prec, only: pReal, pInt
 implicit none

 integer(pInt), intent(in) :: sym
 real(pReal), dimension(3), intent(in) :: Euler
 real(pReal), dimension(3,3) :: math_symmetricEulers
 integer(pInt) i,j
 
 math_symmetricEulers(1,1) = pi+Euler(1)
 math_symmetricEulers(2,1) = Euler(2)
 math_symmetricEulers(3,1) = Euler(3)

 math_symmetricEulers(1,2) = pi-Euler(1)
 math_symmetricEulers(2,2) = pi-Euler(2)
 math_symmetricEulers(3,2) = pi+Euler(3)

 math_symmetricEulers(1,3) = 2.0_pReal*pi-Euler(1)
 math_symmetricEulers(2,3) = pi-Euler(2)
 math_symmetricEulers(3,3) = pi+Euler(3)

 forall (i=1:3,j=1:3) math_symmetricEulers(j,i) = modulo(math_symmetricEulers(j,i),2.0_pReal*pi)

 select case (sym)
   case (4) ! all done

   case (2)  ! return only first
     math_symmetricEulers(:,2:3) = 0.0_pReal

   case default         ! return blank
     math_symmetricEulers = 0.0_pReal
 end select


 endfunction math_symmetricEulers



!********************************************************************
!   draw a random sample from Gauss variable
!********************************************************************
function math_sampleGaussVar(meanvalue, stddev, width)

use prec, only: pReal, pInt
implicit none

!*** input variables
real(pReal), intent(in) ::            meanvalue, &      ! meanvalue of gauss distribution
                                      stddev            ! standard deviation of gauss distribution
real(pReal), intent(in), optional ::  width             ! width of considered values as multiples of standard deviation

!*** output variables
real(pReal)                           math_sampleGaussVar

!*** local variables
real(pReal), dimension(2) ::          rnd               ! random numbers
real(pReal)                           scatter, &        ! normalized scatter around meanvalue
                                      myWidth

if (stddev == 0.0) then
    math_sampleGaussVar = meanvalue
    return
endif

if (present(width)) then
  myWidth = width
else
  myWidth = 3.0_pReal                                         ! use +-3*sigma as default value for scatter
endif

do
  call halton(2, rnd)
  scatter = myWidth * (2.0_pReal * rnd(1) - 1.0_pReal)
  if (rnd(2) <= exp(-0.5_pReal * scatter ** 2.0_pReal)) &     ! test if scattered value is drawn
    exit
enddo

math_sampleGaussVar = scatter * stddev

endfunction math_sampleGaussVar
 


!****************************************************************
 pure subroutine math_pDecomposition(FE,U,R,error)
!-----FE = R.U 
!****************************************************************
 use prec, only: pReal, pInt
 implicit none

 real(pReal), intent(in) :: FE(3,3)
 real(pReal), intent(out) :: R(3,3), U(3,3)
 logical, intent(out) :: error
 real(pReal) CE(3,3),EW1,EW2,EW3,EB1(3,3),EB2(3,3),EB3(3,3),UI(3,3),det

 error = .false.
 ce = math_mul33x33(math_transpose3x3(FE),FE)

 CALL math_spectral1(CE,EW1,EW2,EW3,EB1,EB2,EB3)
 U=sqrt(EW1)*EB1+sqrt(EW2)*EB2+sqrt(EW3)*EB3
 call math_invert3x3(U,UI,det,error)
 if (.not. error) R = math_mul33x33(FE,UI)

 
 ENDSUBROUTINE math_pDecomposition


!**********************************************************************
 pure subroutine math_spectral1(M,EW1,EW2,EW3,EB1,EB2,EB3)
!**** EIGENWERTE UND EIGENWERTBASIS DER SYMMETRISCHEN 3X3 MATRIX M

 use prec, only: pReal, pInt
 implicit none

 real(pReal), intent(in) :: M(3,3)
 real(pReal), intent(out) :: EB1(3,3),EB2(3,3),EB3(3,3),EW1,EW2,EW3
 real(pReal) HI1M,HI2M,HI3M,TOL,R,S,T,P,Q,RHO,PHI,Y1,Y2,Y3,D1,D2,D3
 real(pReal) C1,C2,C3,M1(3,3),M2(3,3),M3(3,3),arg
 TOL=1.e-14_pReal
 CALL math_hi(M,HI1M,HI2M,HI3M)
 R=-HI1M
 S= HI2M
 T=-HI3M
 P=S-R**2.0_pReal/3.0_pReal
 Q=2.0_pReal/27.0_pReal*R**3.0_pReal-R*S/3.0_pReal+T
 EB1=0.0_pReal
 EB2=0.0_pReal
 EB3=0.0_pReal
 IF((ABS(P).LT.TOL).AND.(ABS(Q).LT.TOL))THEN
!   DREI GLEICHE EIGENWERTE
   EW1=HI1M/3.0_pReal
   EW2=EW1
   EW3=EW1
!   this is not really correct, but this way U is calculated
!   correctly in PDECOMPOSITION (correct is EB?=I)
   EB1(1,1)=1.0_pReal
   EB2(2,2)=1.0_pReal
   EB3(3,3)=1.0_pReal
 ELSE
   RHO=sqrt(-3.0_pReal*P**3.0_pReal)/9.0_pReal
   arg=-Q/RHO/2.0_pReal
   if(arg.GT.1) arg=1
   if(arg.LT.-1) arg=-1
   PHI=acos(arg)
   Y1=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal)
   Y2=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal+2.0_pReal/3.0_pReal*PI)
   Y3=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal+4.0_pReal/3.0_pReal*PI)
   EW1=Y1-R/3.0_pReal
   EW2=Y2-R/3.0_pReal
   EW3=Y3-R/3.0_pReal
   C1=ABS(EW1-EW2)
   C2=ABS(EW2-EW3) 
   C3=ABS(EW3-EW1)

   IF(C1.LT.TOL) THEN
!  EW1 is equal to EW2
  D3=1.0_pReal/(EW3-EW1)/(EW3-EW2)
  M1=M-EW1*math_I3
  M2=M-EW2*math_I3
  EB3=math_mul33x33(M1,M2)*D3

  EB1=math_I3-EB3
!  both EB2 and EW2 are set to zero so that they do not
!  contribute to U in PDECOMPOSITION
  EW2=0.0_pReal
   ELSE IF(C2.LT.TOL) THEN
!  EW2 is equal to EW3
  D1=1.0_pReal/(EW1-EW2)/(EW1-EW3)
  M2=M-math_I3*EW2
  M3=M-math_I3*EW3
  EB1=math_mul33x33(M2,M3)*D1
  EB2=math_I3-EB1
!  both EB3 and EW3 are set to zero so that they do not
!  contribute to U in PDECOMPOSITION
  EW3=0.0_pReal
   ELSE IF(C3.LT.TOL) THEN
!  EW1 is equal to EW3
  D2=1.0_pReal/(EW2-EW1)/(EW2-EW3) 
  M1=M-math_I3*EW1
  M3=M-math_I3*EW3
  EB2=math_mul33x33(M1,M3)*D2
  EB1=math_I3-EB2
!  both EB3 and EW3 are set to zero so that they do not
!  contribute to U in PDECOMPOSITION
  EW3=0.0_pReal
   ELSE
!  all three eigenvectors are different
  D1=1.0_pReal/(EW1-EW2)/(EW1-EW3)
  D2=1.0_pReal/(EW2-EW1)/(EW2-EW3) 
  D3=1.0_pReal/(EW3-EW1)/(EW3-EW2)
  M1=M-EW1*math_I3
  M2=M-EW2*math_I3
  M3=M-EW3*math_I3
  EB1=math_mul33x33(M2,M3)*D1
  EB2=math_mul33x33(M1,M3)*D2
  EB3=math_mul33x33(M1,M2)*D3

   END IF
 END IF

 ENDSUBROUTINE math_spectral1

!**********************************************************************
 function math_eigenvalues3x3(M)
!**** Eigenvalues of symmetric 3X3 matrix M

 use prec, only: pReal, pInt
 implicit none

 real(pReal), intent(in) :: M(3,3)
 real(pReal), dimension(3,3) :: EB1(3,3),EB2(3,3),EB3(3,3)
 real(pReal), dimension(3) :: math_eigenvalues3x3
 real(pReal) HI1M,HI2M,HI3M,TOL,R,S,T,P,Q,RHO,PHI,Y1,Y2,Y3,arg,EW1,EW2,EW3
 TOL=1.e-14_pReal
 CALL math_hi(M,HI1M,HI2M,HI3M)
 R=-HI1M
 S= HI2M
 T=-HI3M
 P=S-R**2.0_pReal/3.0_pReal
 Q=2.0_pReal/27.0_pReal*R**3.0_pReal-R*S/3.0_pReal+T
 EB1=0.0_pReal
 EB2=0.0_pReal
 EB3=0.0_pReal
 if((abs(P) < TOL) .and. (abs(Q) < TOL)) THEN
! three equivalent eigenvalues
   math_eigenvalues3x3(1) = HI1M/3.0_pReal
   math_eigenvalues3x3(2)=math_eigenvalues3x3(1)
   math_eigenvalues3x3(3)=math_eigenvalues3x3(1)
!   this is not really correct, but this way U is calculated
!   correctly in PDECOMPOSITION (correct is EB?=I)
   EB1(1,1)=1.0_pReal
   EB2(2,2)=1.0_pReal
   EB3(3,3)=1.0_pReal
 else
   RHO=sqrt(-3.0_pReal*P**3.0_pReal)/9.0_pReal
   arg=-Q/RHO/2.0_pReal
   if(arg.GT.1) arg=1
   if(arg.LT.-1) arg=-1
   PHI=acos(arg)
   Y1=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal)
   Y2=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal+2.0_pReal/3.0_pReal*PI)
   Y3=2*RHO**(1.0_pReal/3.0_pReal)*cos(PHI/3.0_pReal+4.0_pReal/3.0_pReal*PI)
   math_eigenvalues3x3(1) = Y1-R/3.0_pReal
   math_eigenvalues3x3(2) = Y2-R/3.0_pReal
   math_eigenvalues3x3(3) = Y3-R/3.0_pReal
 endif
 endfunction  math_eigenvalues3x3

!********************************************************************** 
!**** HAUPTINVARIANTEN HI1M, HI2M, HI3M DER 3X3 MATRIX M

 PURE SUBROUTINE math_hi(M,HI1M,HI2M,HI3M)
 use prec, only: pReal, pInt
 implicit none

 real(pReal), intent(in) :: M(3,3) 
 real(pReal), intent(out) :: HI1M, HI2M, HI3M 

 HI1M=M(1,1)+M(2,2)+M(3,3)
 HI2M=HI1M**2/2.0_pReal-(M(1,1)**2+M(2,2)**2+M(3,3)**2)/2.0_pReal-M(1,2)*M(2,1)-M(1,3)*M(3,1)-M(2,3)*M(3,2)
 HI3M=math_det3x3(M)
! QUESTION: is 3rd equiv det(M) ?? if yes, use function math_det !agreed on YES

 ENDSUBROUTINE math_hi


 SUBROUTINE get_seed(seed)
!
!*******************************************************************************
!
!! GET_SEED returns a seed for the random number generator.
!
!
!  Discussion:
!
! The seed depends on the current time, and ought to be (slightly)
! different every millisecond. Once the seed is obtained, a random
! number generator should be called a few times to further process
! the seed.
!
!  Modified:
!
! 27 June 2000
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Output, integer SEED, a pseudorandom seed value.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, only: pReal, pInt
 implicit none

 integer(pInt) seed
 real(pReal)  temp
 character ( len = 10 ) time
 character ( len = 8 ) today
 integer(pInt) values(8)
 character ( len = 5 ) zone

 call date_and_time ( today, time, zone, values )

 temp = 0.0D+00

 temp = temp + dble ( values(2) - 1 ) / 11.0D+00
 temp = temp + dble ( values(3) - 1 ) / 30.0D+00
 temp = temp + dble ( values(5) ) / 23.0D+00
 temp = temp + dble ( values(6) ) / 59.0D+00
 temp = temp + dble ( values(7) ) / 59.0D+00
 temp = temp + dble ( values(8) ) / 999.0D+00
 temp = temp / 6.0D+00

 if ( temp <= 0.0D+00 ) then
   temp = 1.0D+00 / 3.0D+00
 else if ( 1.0D+00 <= temp ) then
   temp = 2.0D+00 / 3.0D+00
 end if

 seed = int ( dble ( huge ( 1 ) ) * temp , pInt)
!
!  Never use a seed of 0 or maximum integer.
!
 if ( seed == 0 ) then
   seed = 1
 end if

 if ( seed == huge ( 1 ) ) then
   seed = seed - 1
 end if


 ENDSUBROUTINE get_seed


 subroutine halton ( ndim, r )
!
!*******************************************************************************
!
!! HALTON computes the next element in the Halton sequence.
!
!
!  Modified:
!
! 09 March 2003
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Input, integer NDIM, the dimension of the element.
!
! Output, real R(NDIM), the next element of the current Halton
! sequence.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, ONLY: pReal, pInt
 implicit none

 integer(pInt) ndim

 integer(pInt) base(ndim)
 real(pReal) r(ndim)
 integer(pInt) seed
 integer(pInt) value(1)

 call halton_memory ( 'GET', 'SEED', 1, value )
 seed = value(1)

 call halton_memory ( 'GET', 'BASE', ndim, base )

 call i_to_halton ( seed, base, ndim, r )

 value(1) = 1
 call halton_memory ( 'INC', 'SEED', 1, value )


 ENDSUBROUTINE halton


 subroutine halton_memory ( action, name, ndim, value )
!
!*******************************************************************************
!
!! HALTON_MEMORY sets or returns quantities associated with the Halton sequence.
!
!
!  Modified:
!
! 09 March 2003
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Input, character ( len = * ) ACTION, the desired action.
! 'GET' means get the value of a particular quantity.
! 'SET' means set the value of a particular quantity.
! 'INC' means increment the value of a particular quantity.
!  (Only the SEED can be incremented.)
!
! Input, character ( len = * ) NAME, the name of the quantity.
! 'BASE' means the Halton base or bases.
! 'NDIM' means the spatial dimension.
! 'SEED' means the current Halton seed.
!
! Input/output, integer NDIM, the dimension of the quantity.
! If ACTION is 'SET' and NAME is 'BASE', then NDIM is input, and
! is the number of entries in VALUE to be put into BASE.
!
! Input/output, integer VALUE(NDIM), contains a value.
! If ACTION is 'SET', then on input, VALUE contains values to be assigned
! to the internal variable.
! If ACTION is 'GET', then on output, VALUE contains the values of
! the specified internal variable.
! If ACTION is 'INC', then on input, VALUE contains the increment to
! be added to the specified internal variable.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, only: pReal, pInt
 implicit none

 character ( len = * ) action
 integer(pInt), allocatable, save :: base(:)
 logical, save :: first_call = .true.
 integer(pInt) i
 character ( len = * ) name
 integer(pInt) ndim
 integer(pInt), save :: ndim_save = 0
 integer(pInt), save :: seed = 1
 integer(pInt) value(*)

 if ( first_call ) then
   ndim_save = 1
   allocate ( base(ndim_save) )
   base(1) = 2
   first_call = .false.
 end if
!
!  Set
!
 if ( action(1:1) == 'S' .or. action(1:1) == 's' ) then

   if ( name(1:1) == 'B' .or. name(1:1) == 'b' ) then

     if ( ndim_save /= ndim ) then
       deallocate ( base )
       ndim_save = ndim
       allocate ( base(ndim_save) )
     end if

     base(1:ndim) = value(1:ndim)

   else if ( name(1:1) == 'N' .or. name(1:1) == 'n' ) then

     if ( ndim_save /= value(1) ) then
       deallocate ( base )
       ndim_save = value(1)
       allocate ( base(ndim_save) )
       do i = 1, ndim_save
         base(i) = prime ( i )
       enddo
     else
       ndim_save = value(1)
     end if
   else if ( name(1:1) == 'S' .or. name(1:1) == 's' ) then
     seed = value(1)
 end if
!
!  Get
!
 else if ( action(1:1) == 'G' .or. action(1:1) == 'g' ) then
   if ( name(1:1) == 'B' .or. name(1:1) == 'b' ) then
     if ( ndim /= ndim_save ) then
  deallocate ( base )
  ndim_save = ndim
  allocate ( base(ndim_save) )
  do i = 1, ndim_save
    base(i) = prime(i)
  enddo
     end if
     value(1:ndim_save) = base(1:ndim_save)
   else if ( name(1:1) == 'N' .or. name(1:1) == 'n' ) then
     value(1) = ndim_save
   else if ( name(1:1) == 'S' .or. name(1:1) == 's' ) then
     value(1) = seed
   end if
!
!  Increment
!
 else if ( action(1:1) == 'I' .or. action(1:1) == 'i' ) then
   if ( name(1:1) == 'S' .or. name(1:1) == 's' ) then
     seed = seed + value(1)
   end if
 end if


 ENDSUBROUTINE halton_memory


 subroutine halton_ndim_set ( ndim )
!
!*******************************************************************************
!
!! HALTON_NDIM_SET sets the dimension for a Halton sequence.
!
!
!  Modified:
!
! 26 February 2001
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Input, integer NDIM, the dimension of the Halton vectors.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, only: pReal, pInt
 implicit none

 integer(pInt) ndim
 integer(pInt) value(1)

 value(1) = ndim
 call halton_memory ( 'SET', 'NDIM', 1, value )


 ENDSUBROUTINE halton_ndim_set


 subroutine halton_seed_set ( seed )
!
!*******************************************************************************
!
!! HALTON_SEED_SET sets the "seed" for the Halton sequence.
!
!
!  Discussion:
!
! Calling HALTON repeatedly returns the elements of the
! Halton sequence in order, starting with element number 1.
! An internal counter, called SEED, keeps track of the next element
! to return. Each time the routine is called, the SEED-th element
! is computed, and then SEED is incremented by 1.
!
! To restart the Halton sequence, it is only necessary to reset
! SEED to 1. It might also be desirable to reset SEED to some other value.
! This routine allows the user to specify any value of SEED.
!
! The default value of SEED is 1, which restarts the Halton sequence.
!
!  Modified:
!
! 26 February 2001
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Input, integer SEED, the seed for the Halton sequence.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, only: pReal, pInt
 implicit none

 integer(pInt), parameter :: ndim = 1

 integer(pInt) seed
 integer(pInt) value(ndim)

 value(1) = seed
 call halton_memory ( 'SET', 'SEED', ndim, value )


 ENDSUBROUTINE halton_seed_set


 subroutine i_to_halton ( seed, base, ndim, r )
!
!*******************************************************************************
!
!! I_TO_HALTON computes an element of a Halton sequence.
!
!
!  Reference:
!
! J H Halton,
! On the efficiency of certain quasi-random sequences of points
! in evaluating multi-dimensional integrals,
! Numerische Mathematik,
! Volume 2, pages 84-90, 1960.
!
!  Modified:
!
! 26 February 2001
!
!  Author:
!
! John Burkardt
!
!  Parameters:
!
! Input, integer SEED, the index of the desired element.
! Only the absolute value of SEED is considered. SEED = 0 is allowed,
! and returns R = 0.
!
! Input, integer BASE(NDIM), the Halton bases, which should be
! distinct prime numbers.  This routine only checks that each base
! is greater than 1.
!
! Input, integer NDIM, the dimension of the sequence.
!
! Output, real R(NDIM), the SEED-th element of the Halton sequence
! for the given bases.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, ONLY: pReal, pInt
 implicit none

 integer(pInt) ndim

 integer(pInt) base(ndim)
 real(pReal) base_inv(ndim)
 integer(pInt) digit(ndim)
 integer(pInt) i
 real(pReal) r(ndim)
 integer(pInt) seed
 integer(pInt) seed2(ndim)

 seed2(1:ndim) = abs ( seed )

 r(1:ndim) = 0.0_pReal

 if ( any ( base(1:ndim) <= 1 ) ) then
   !$OMP CRITICAL (write2out)
   write ( *, '(a)' ) ' '
   write ( *, '(a)' ) 'I_TO_HALTON - Fatal error!'
   write ( *, '(a)' ) ' An input base BASE is <= 1!'
   do i = 1, ndim
     write ( *, '(i6,i6)' ) i, base(i)
   enddo
   call flush(6)
   !$OMP END CRITICAL (write2out)
   stop
 end if

 base_inv(1:ndim) = 1.0_pReal / real ( base(1:ndim), pReal )

 do while ( any ( seed2(1:ndim) /= 0 ) )
   digit(1:ndim) = mod ( seed2(1:ndim), base(1:ndim) )
   r(1:ndim) = r(1:ndim) + real ( digit(1:ndim), pReal ) * base_inv(1:ndim)
   base_inv(1:ndim) = base_inv(1:ndim) / real ( base(1:ndim), pReal )
   seed2(1:ndim) = seed2(1:ndim) / base(1:ndim)
 enddo


 ENDSUBROUTINE i_to_halton


 function prime ( n )
!
!*******************************************************************************
!
!! PRIME returns any of the first PRIME_MAX prime numbers.
!
!
!  Note:
!
! PRIME_MAX is 1500, and the largest prime stored is 12553.
!
!  Modified:
!
! 21 June 2002
!
!  Author:
!
! John Burkardt
!
!  Reference:
!
! Milton Abramowitz and Irene Stegun,
! Handbook of Mathematical Functions,
! US Department of Commerce, 1964, pages 870-873.
!
! Daniel Zwillinger,
! CRC Standard Mathematical Tables and Formulae,
! 30th Edition,
! CRC Press, 1996, pages 95-98.
!
!  Parameters:
!
! Input, integer N, the index of the desired prime number.
! N = -1 returns PRIME_MAX, the index of the largest prime available.
! N = 0 is legal, returning PRIME = 1.
! It should generally be true that 0 <= N <= PRIME_MAX.
!
! Output, integer PRIME, the N-th prime.  If N is out of range, PRIME
! is returned as 0.
!
!  Modified:
!
! 29 April 2005
!
!  Author:
!
! Franz Roters
!
 use prec, only: pReal, pInt
 implicit none

 integer(pInt), parameter :: prime_max = 1500

 integer(pInt), save :: icall = 0
 integer(pInt) n
 integer(pInt), save, dimension ( prime_max ) :: npvec
 integer(pInt) prime

 if ( icall == 0 ) then

 icall = 1

 npvec(1:100) = (/&
        2,    3,    5,    7,   11,   13,   17,   19,   23,   29, &
       31,   37,   41,   43,   47,   53,   59,   61,   67,   71, &
       73,   79,   83,   89,   97,  101,  103,  107,  109,  113, &
      127,  131,  137,  139,  149,  151,  157,  163,  167,  173, &
      179,  181,  191,  193,  197,  199,  211,  223,  227,  229, &
      233,  239,  241,  251,  257,  263,  269,  271,  277,  281, &
      283,  293,  307,  311,  313,  317,  331,  337,  347,  349, &
      353,  359,  367,  373,  379,  383,  389,  397,  401,  409, &
      419,  421,  431,  433,  439,  443,  449,  457,  461,  463, &
      467,  479,  487,  491,  499,  503,  509,  521,  523,  541 /)

 npvec(101:200) = (/ &
       547,  557,  563,  569,  571,  577,  587,  593,  599,  601, &
       607,  613,  617,  619,  631,  641,  643,  647,  653,  659, &
       661,  673,  677,  683,  691,  701,  709,  719,  727,  733, &
       739,  743,  751,  757,  761,  769,  773,  787,  797,  809, &
       811,  821,  823,  827,  829,  839,  853,  857,  859,  863, &
       877,  881,  883,  887,  907,  911,  919,  929,  937,  941, &
       947,  953,  967,  971,  977,  983,  991,  997, 1009, 1013, &
      1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, &
      1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, &
      1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223 /)

 npvec(201:300) = (/ &
      1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, &
      1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, &
      1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439, 1447, 1451, &
      1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511, &
      1523, 1531, 1543, 1549, 1553, 1559, 1567, 1571, 1579, 1583, &
      1597, 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, &
      1663, 1667, 1669, 1693, 1697, 1699, 1709, 1721, 1723, 1733, &
      1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789, 1801, 1811, &
      1823, 1831, 1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889, &
      1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987 /)

 npvec(301:400) = (/ &
      1993, 1997, 1999, 2003, 2011, 2017, 2027, 2029, 2039, 2053, &
      2063, 2069, 2081, 2083, 2087, 2089, 2099, 2111, 2113, 2129, &
      2131, 2137, 2141, 2143, 2153, 2161, 2179, 2203, 2207, 2213, &
      2221, 2237, 2239, 2243, 2251, 2267, 2269, 2273, 2281, 2287, &
      2293, 2297, 2309, 2311, 2333, 2339, 2341, 2347, 2351, 2357, &
      2371, 2377, 2381, 2383, 2389, 2393, 2399, 2411, 2417, 2423, &
      2437, 2441, 2447, 2459, 2467, 2473, 2477, 2503, 2521, 2531, &
      2539, 2543, 2549, 2551, 2557, 2579, 2591, 2593, 2609, 2617, &
      2621, 2633, 2647, 2657, 2659, 2663, 2671, 2677, 2683, 2687, &
      2689, 2693, 2699, 2707, 2711, 2713, 2719, 2729, 2731, 2741 /)

 npvec(401:500) = (/ &
      2749, 2753, 2767, 2777, 2789, 2791, 2797, 2801, 2803, 2819, &
      2833, 2837, 2843, 2851, 2857, 2861, 2879, 2887, 2897, 2903, &
      2909, 2917, 2927, 2939, 2953, 2957, 2963, 2969, 2971, 2999, &
      3001, 3011, 3019, 3023, 3037, 3041, 3049, 3061, 3067, 3079, &
      3083, 3089, 3109, 3119, 3121, 3137, 3163, 3167, 3169, 3181, &
      3187, 3191, 3203, 3209, 3217, 3221, 3229, 3251, 3253, 3257, &
      3259, 3271, 3299, 3301, 3307, 3313, 3319, 3323, 3329, 3331, &
      3343, 3347, 3359, 3361, 3371, 3373, 3389, 3391, 3407, 3413, &
      3433, 3449, 3457, 3461, 3463, 3467, 3469, 3491, 3499, 3511, &
      3517, 3527, 3529, 3533, 3539, 3541, 3547, 3557, 3559, 3571 /)

 npvec(501:600) = (/ &
      3581, 3583, 3593, 3607, 3613, 3617, 3623, 3631, 3637, 3643, &
      3659, 3671, 3673, 3677, 3691, 3697, 3701, 3709, 3719, 3727, &
      3733, 3739, 3761, 3767, 3769, 3779, 3793, 3797, 3803, 3821, &
      3823, 3833, 3847, 3851, 3853, 3863, 3877, 3881, 3889, 3907, &
      3911, 3917, 3919, 3923, 3929, 3931, 3943, 3947, 3967, 3989, &
      4001, 4003, 4007, 4013, 4019, 4021, 4027, 4049, 4051, 4057, &
      4073, 4079, 4091, 4093, 4099, 4111, 4127, 4129, 4133, 4139, &
      4153, 4157, 4159, 4177, 4201, 4211, 4217, 4219, 4229, 4231, &
      4241, 4243, 4253, 4259, 4261, 4271, 4273, 4283, 4289, 4297, &
      4327, 4337, 4339, 4349, 4357, 4363, 4373, 4391, 4397, 4409 /)

 npvec(601:700) = (/ &
      4421, 4423, 4441, 4447, 4451, 4457, 4463, 4481, 4483, 4493, &
      4507, 4513, 4517, 4519, 4523, 4547, 4549, 4561, 4567, 4583, &
      4591, 4597, 4603, 4621, 4637, 4639, 4643, 4649, 4651, 4657, &
      4663, 4673, 4679, 4691, 4703, 4721, 4723, 4729, 4733, 4751, &
      4759, 4783, 4787, 4789, 4793, 4799, 4801, 4813, 4817, 4831, &
      4861, 4871, 4877, 4889, 4903, 4909, 4919, 4931, 4933, 4937, &
      4943, 4951, 4957, 4967, 4969, 4973, 4987, 4993, 4999, 5003, &
      5009, 5011, 5021, 5023, 5039, 5051, 5059, 5077, 5081, 5087, &
      5099, 5101, 5107, 5113, 5119, 5147, 5153, 5167, 5171, 5179, &
      5189, 5197, 5209, 5227, 5231, 5233, 5237, 5261, 5273, 5279 /)

 npvec(701:800) = (/ &
      5281, 5297, 5303, 5309, 5323, 5333, 5347, 5351, 5381, 5387, &
      5393, 5399, 5407, 5413, 5417, 5419, 5431, 5437, 5441, 5443, &
      5449, 5471, 5477, 5479, 5483, 5501, 5503, 5507, 5519, 5521, &
      5527, 5531, 5557, 5563, 5569, 5573, 5581, 5591, 5623, 5639, &
      5641, 5647, 5651, 5653, 5657, 5659, 5669, 5683, 5689, 5693, &
      5701, 5711, 5717, 5737, 5741, 5743, 5749, 5779, 5783, 5791, &
      5801, 5807, 5813, 5821, 5827, 5839, 5843, 5849, 5851, 5857, &
      5861, 5867, 5869, 5879, 5881, 5897, 5903, 5923, 5927, 5939, &
      5953, 5981, 5987, 6007, 6011, 6029, 6037, 6043, 6047, 6053, &
      6067, 6073, 6079, 6089, 6091, 6101, 6113, 6121, 6131, 6133 /)

 npvec(801:900) = (/ &
      6143, 6151, 6163, 6173, 6197, 6199, 6203, 6211, 6217, 6221, &
      6229, 6247, 6257, 6263, 6269, 6271, 6277, 6287, 6299, 6301, &
      6311, 6317, 6323, 6329, 6337, 6343, 6353, 6359, 6361, 6367, &
      6373, 6379, 6389, 6397, 6421, 6427, 6449, 6451, 6469, 6473, &
      6481, 6491, 6521, 6529, 6547, 6551, 6553, 6563, 6569, 6571, &
      6577, 6581, 6599, 6607, 6619, 6637, 6653, 6659, 6661, 6673, &
      6679, 6689, 6691, 6701, 6703, 6709, 6719, 6733, 6737, 6761, &
      6763, 6779, 6781, 6791, 6793, 6803, 6823, 6827, 6829, 6833, &
      6841, 6857, 6863, 6869, 6871, 6883, 6899, 6907, 6911, 6917, &
      6947, 6949, 6959, 6961, 6967, 6971, 6977, 6983, 6991, 6997 /)

 npvec(901:1000) = (/ &
      7001, 7013, 7019, 7027, 7039, 7043, 7057, 7069, 7079, 7103, &
      7109, 7121, 7127, 7129, 7151, 7159, 7177, 7187, 7193, 7207, &
      7211, 7213, 7219, 7229, 7237, 7243, 7247, 7253, 7283, 7297, &
      7307, 7309, 7321, 7331, 7333, 7349, 7351, 7369, 7393, 7411, &
      7417, 7433, 7451, 7457, 7459, 7477, 7481, 7487, 7489, 7499, &
      7507, 7517, 7523, 7529, 7537, 7541, 7547, 7549, 7559, 7561, &
      7573, 7577, 7583, 7589, 7591, 7603, 7607, 7621, 7639, 7643, &
      7649, 7669, 7673, 7681, 7687, 7691, 7699, 7703, 7717, 7723, &
      7727, 7741, 7753, 7757, 7759, 7789, 7793, 7817, 7823, 7829, &
      7841, 7853, 7867, 7873, 7877, 7879, 7883, 7901, 7907, 7919 /)

 npvec(1001:1100) = (/ &
      7927, 7933, 7937, 7949, 7951, 7963, 7993, 8009, 8011, 8017, &
      8039, 8053, 8059, 8069, 8081, 8087, 8089, 8093, 8101, 8111, &
      8117, 8123, 8147, 8161, 8167, 8171, 8179, 8191, 8209, 8219, &
      8221, 8231, 8233, 8237, 8243, 8263, 8269, 8273, 8287, 8291, &
      8293, 8297, 8311, 8317, 8329, 8353, 8363, 8369, 8377, 8387, &
      8389, 8419, 8423, 8429, 8431, 8443, 8447, 8461, 8467, 8501, &
      8513, 8521, 8527, 8537, 8539, 8543, 8563, 8573, 8581, 8597, &
      8599, 8609, 8623, 8627, 8629, 8641, 8647, 8663, 8669, 8677, &
      8681, 8689, 8693, 8699, 8707, 8713, 8719, 8731, 8737, 8741, &
      8747, 8753, 8761, 8779, 8783, 8803, 8807, 8819, 8821, 8831 /)

 npvec(1101:1200) = (/ &
      8837, 8839, 8849, 8861, 8863, 8867, 8887, 8893, 8923, 8929, &
      8933, 8941, 8951, 8963, 8969, 8971, 8999, 9001, 9007, 9011, &
      9013, 9029, 9041, 9043, 9049, 9059, 9067, 9091, 9103, 9109, &
      9127, 9133, 9137, 9151, 9157, 9161, 9173, 9181, 9187, 9199, &
      9203, 9209, 9221, 9227, 9239, 9241, 9257, 9277, 9281, 9283, &
      9293, 9311, 9319, 9323, 9337, 9341, 9343, 9349, 9371, 9377, &
      9391, 9397, 9403, 9413, 9419, 9421, 9431, 9433, 9437, 9439, &
      9461, 9463, 9467, 9473, 9479, 9491, 9497, 9511, 9521, 9533, &
      9539, 9547, 9551, 9587, 9601, 9613, 9619, 9623, 9629, 9631, &
      9643, 9649, 9661, 9677, 9679, 9689, 9697, 9719, 9721, 9733 /)

 npvec(1201:1300) = (/ &
       9739, 9743, 9749, 9767, 9769, 9781, 9787, 9791, 9803, 9811, &
       9817, 9829, 9833, 9839, 9851, 9857, 9859, 9871, 9883, 9887, &
       9901, 9907, 9923, 9929, 9931, 9941, 9949, 9967, 9973,10007, &
      10009,10037,10039,10061,10067,10069,10079,10091,10093,10099, &
      10103,10111,10133,10139,10141,10151,10159,10163,10169,10177, &
      10181,10193,10211,10223,10243,10247,10253,10259,10267,10271, &
      10273,10289,10301,10303,10313,10321,10331,10333,10337,10343, &
      10357,10369,10391,10399,10427,10429,10433,10453,10457,10459, &
      10463,10477,10487,10499,10501,10513,10529,10531,10559,10567, &
      10589,10597,10601,10607,10613,10627,10631,10639,10651,10657 /)

 npvec(1301:1400) = (/ &
      10663,10667,10687,10691,10709,10711,10723,10729,10733,10739, &
      10753,10771,10781,10789,10799,10831,10837,10847,10853,10859, &
      10861,10867,10883,10889,10891,10903,10909,19037,10939,10949, &
      10957,10973,10979,10987,10993,11003,11027,11047,11057,11059, &
      11069,11071,11083,11087,11093,11113,11117,11119,11131,11149, &
      11159,11161,11171,11173,11177,11197,11213,11239,11243,11251, &
      11257,11261,11273,11279,11287,11299,11311,11317,11321,11329, &
      11351,11353,11369,11383,11393,11399,11411,11423,11437,11443, &
      11447,11467,11471,11483,11489,11491,11497,11503,11519,11527, &
      11549,11551,11579,11587,11593,11597,11617,11621,11633,11657 /)

 npvec(1401:1500) = (/ &
      11677,11681,11689,11699,11701,11717,11719,11731,11743,11777, &
      11779,11783,11789,11801,11807,11813,11821,11827,11831,11833, &
      11839,11863,11867,11887,11897,11903,11909,11923,11927,11933, &
      11939,11941,11953,11959,11969,11971,11981,11987,12007,12011, &
      12037,12041,12043,12049,12071,12073,12097,12101,12107,12109, &
      12113,12119,12143,12149,12157,12161,12163,12197,12203,12211, &
      12227,12239,12241,12251,12253,12263,12269,12277,12281,12289, &
      12301,12323,12329,12343,12347,12373,12377,12379,12391,12401, &
      12409,12413,12421,12433,12437,12451,12457,12473,12479,12487, &
      12491,12497,12503,12511,12517,12527,12539,12541,12547,12553 /)

 end if

 if ( n == -1 ) then
   prime = prime_max
 else if ( n == 0 ) then
   prime = 1
 else if ( n <= prime_max ) then
   prime = npvec(n)
 else
   prime = 0
!$OMP CRITICAL (write2out)
   write ( 6, '(a)' ) ' '
   write ( 6, '(a)' ) 'PRIME - Fatal error!'
   write ( 6, '(a,i6)' ) '  Illegal prime index N = ', n
   write ( 6, '(a,i6)' ) '  N must be between 0 and PRIME_MAX =',prime_max
   call flush(6)
!$OMP END CRITICAL (write2out)

   stop
 end if

 endfunction prime

!**************************************************************************
! volume of tetrahedron given by four vertices
!**************************************************************************
 pure function math_volTetrahedron(v1,v2,v3,v4)  

 use prec, only: pReal
 implicit none

 real(pReal) math_volTetrahedron
 real(pReal), dimension (3), intent(in) :: v1,v2,v3,v4
 real(pReal), dimension (3,3) :: m

 m(:,1) = v1-v2
 m(:,2) = v2-v3
 m(:,3) = v3-v4

 math_volTetrahedron = math_det3x3(m)/6.0_pReal 

 endfunction math_volTetrahedron


 END MODULE math
