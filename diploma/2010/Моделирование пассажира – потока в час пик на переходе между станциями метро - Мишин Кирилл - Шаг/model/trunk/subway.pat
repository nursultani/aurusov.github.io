$Pattern �������_�������_������_��_������������: irregular_event 
$Relevant_resources
	_����� : ������ Create
$Time = ����������������_��������(3.275){ �������� ������ �������� �������}
$Body
_����� 
	Convert_event 
		������ set time_now
		Temp set 10
		������� set ������������
		������ set 0
		�����_�_���� set 0
		�����_�������� set 0
		��������_�������� set 0
		��������� set ��������
		���������_���������� set 203
$End

$Pattern �������_�������_��_������������: operation 
$Relevant_resources
	_�����  : ������  Keep Keep
	_�������: ������� Keep Keep
$Time = ����������������_��������(0.295)
$Body
_�����
	Choice from _�����.Temp = 10 and _�����.������� = ������������
	Convert_begin
		Temp set 111
	Convert_end
		Temp set 0
		������ set time_now
		�����_�_���� set _�����.�����_�_���� + _�����.������ - _�����.������
		��������� set �_����

_�������
	Choice from _�������.�������� == _�����.�������
	Convert_begin
		��������� set ���������
	Convert_end
		��������� set ������
$End

$Pattern �������_��������_������������_������������: operation //ToDo: ����������� �������� ������� ������ ������
$Relevant_resources
	_�����  : ������   Keep Keep
	_�������: �������� Keep NoChange
$Time = �����������_��������(14.233, 14.716)
$Body
_�����
	Choice from _�����.Temp = 0 and _�����.������� = ������������
	Convert_begin
		�����_�������� set time_now
		Temp set 1
	Convert_end
		��������_�������� set time_now
		Temp set 2
		�����_�_���� set _�����.�����_�_���� + _�����.��������_�������� - _�����.�����_��������
		
_�������
	Choice from _�������.�� == _�����.�������
	Convert_begin
		����������_������� set _�������.����������_������� + 1
$End

$Pattern �������_�������_������_��_������������: operation 
$Relevant_resources
	_�����  : ������   Keep Keep
	_�������: �������  Keep NoChange
	_�������: �������� Keep NoChange
$Time = �����������_��������(0.166,0.25) // �� 10 �� 15 ������, TODO: �������� �� ���������������� ��������
$Body
_�����
	Choice from _�����.Temp = 2 and _�����.������� = ������������
	Convert_begin
		Temp                 set 3

	Convert_end
		Temp                 set 4
		�����_�_����         set _�����.�����_�_���� + Time_now - _�����.��������_�������� 
		���������            set ��������
		���������_���������� set 0

_�������
	Convert_begin 
		�����������_�������_���������� set ��
		���_�_�������                 set _�����.���������_����������

_�������
	Choice from _�������.�� == _�����.�������
	Convert_begin
		����������_������� set _�������.����������_������� - 1
$End

$Pattern �������_�������_������_��_������_�������: rule 
$Relevant_resources
	_�����    : ������   Erase
$Body
_�����
	Choice from _�����.��������� = �������� and _�����.������� = ������������
$End

////////

$Pattern �������_����������_�������: operation 
$Relevant_resources
	_������� : ������� Keep Keep
$Time = 0.166
$Body
_�������
	Choice from _�������.�����������_�������_���������� = �� and _�������.���_�_������� > 0
	Convert_begin
		�����������_�������_���������� set �_��������
	Convert_end
		�����������_�������_���������� set ���
		������                         set _�������.������ + _�������.���_�_�������
		���_�_�������                 set 0
$End


$Pattern �������_����������_�������_�������: irregular_event 
$Relevant_resources
	_���������_1	: ���������_1	Keep
	_���������_2	: ���������_2	Keep
	_���������_3	: ���������_3	Keep
$Time = 0.016 //����� ������� 2 �������� 1 �������
$Body
_���������_1
	Convert_event
		�����������_�������_����������	set ��
_���������_2
	Convert_event
		�����������_�������_����������	set ��
_���������_3
	Convert_event
		�����������_�������_����������	set ��
$End

$Pattern �������_����������_�������_�������: rule 
$Relevant_resources
	_���������	: ����������	Keep
	_������� 	: �������		Keep
$Body
_���������
	Choice from _���������.�����������_�������_���������� = ��
	Convert_rule
		�����������_�������_����������	set ���
_�������
	Choice from _�������.������ > 0
	Convert_rule
		������ set _�������.������ - 1
$End

///////////
$Pattern �������_�������_������_��_������������: irregular_event 
$Relevant_resources
	_����� : ������ Create
$Time = ����������������_��������(3.275){ �������� ������ �������� �������}
$Body
_����� 
	Convert_event 
		������ set time_now
		Temp set 10
		������� set ������������
		������ set 0
		�����_�_���� set 0
		�����_�������� set 0
		��������_�������� set 0
		��������� set ��������
		���������_���������� set 203 
$End

$Pattern �������_�������_��_������������: operation 
$Relevant_resources
	_����� : ������ Keep Keep
	_�������: ������� Keep Keep
$Time = ����������������_��������(0.295)
$Body
_�����
	Choice from _�����.Temp = 10 and _�����.������� = ������������
	Convert_begin
		Temp set 111
	Convert_end
		Temp set 0
		������ set time_now
		�����_�_���� set _�����.�����_�_���� + _�����.������ - _�����.������
		��������� set �_����
		
_�������
	Choice from _�������.�������� == _�����.�������
	Convert_begin
		��������� set ���������
	Convert_end
		��������� set ������
$End

$Pattern �������_��������_������������_�������: operation 
$Relevant_resources
	_����� : ������ Keep Keep
	_�������: �������� Keep NoChange
$Time = �����������_��������(6.066,6.533) 
$Body
_�����
	Choice from _�����.Temp = 0 and _�����.������� = ������������
	Convert_begin
		�����_�������� set time_now
		Temp set 1
	Convert_end
		��������_�������� set time_now
		Temp set 2
		�����_�_���� set _�����.�����_�_���� + _�����.��������_�������� - _�����.�����_��������
		��������� set ��������
		
_�������
	Choice from _�������.�� == _�����.�������
	Convert_begin
		����������_������� set _�������.����������_������� + 1
$End

$Pattern �������_�������_������_��_������_�������: rule 
$Relevant_resources
	_����� : ������ Erase
	_�������: �������� Keep
$Body
_�����
	Choice from _�����.��������� = �������� and _�����.������� = ������������
	
_�������
	Choice from _�������.�� == _�����.�������
	Convert_rule
		����������_������� set _�������.����������_������� - 1
$End

