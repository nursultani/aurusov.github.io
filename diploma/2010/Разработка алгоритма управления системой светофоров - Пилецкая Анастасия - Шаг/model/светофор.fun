$Constant
  ��������_�����_�������� : real = 0.0
$End  

$Sequence ��������_�������_����� : real
$Type = exponential 123456789
$End

$Sequence ��������_����_�������������_�������� : such_as ������������_��������.���
$Type = by_hist 123456789
$Body
	��������       89
	������������    6
	����������      3
	�������         2
$End

$Sequence ��������_������_�������_������: such_as ������������_��������.�����_������
$Type = by_hist 123456789
$Body
	������_1   24
	������_2   24
	������_3   24
	������_4   26
$End

$Function �����_������: real
$Type = table
$Parameters
	��������_1: such_as ������������_��������.���
$Body
	2.5 4.0 10.0 11.0
$End

$Function ������: such_as ������.������
$Type = algorithmic
$Parameters
	�����_������: such_as ������.�����_������
$Body
	if �����_������ == ������_1 or
	   �����_������ == ������_2 or
	   �����_������ == ������_3 or
	   �����_������ == ������_4 result = �������
	result = ��������������
$End //��� ����� ������ ������ � ������� �����

$Function ���������_�����_������: real
$Type = algorithmic
$Parameters
	�����_������: real
$Body
	if �����_������ == 0.0 result = 0.0
	result = �����_������ + ��������_�����_��������
$End

