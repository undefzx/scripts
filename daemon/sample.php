<?php

// ������� �������� �������
// ���� ��� ����� pcntl_fork() ����� ����������� ����� ����������: ������������ � ��������
$child_pid = pcntl_fork();
if ($child_pid) {
    // ������� �� �������������, ������������ � �������, ��������
    exit();
}
// ������ �������� ��������� ��������.
posix_setsid();

// ���������� ��� ���������� ������ �������� ���������, ������� ��� ������� �� �������

?>