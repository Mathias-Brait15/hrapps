class InteractionModel {
  String id;
  String note;
  String branch;
  String namaSales;
  String namaPensiunan;
  String jamKunjungan;
  String keterangan;
  String cabangAkad;
  String nikMarsit;
  String foto1;

  //BUAT CONSTRUCTOR AGAR KETIKA CLASS INI DILOAD, MAKA DATA YANG DIMINTA HARUS DIPASSING SESUAI TIPE DATA YANG DITETAPKAN
  InteractionModel(
      {this.id,
      this.note,
      this.branch,
      this.namaSales,
      this.namaPensiunan,
      this.jamKunjungan,
      this.keterangan,
      this.cabangAkad,
      this.nikMarsit,
      this.foto1});

  //FUNGSI INI UNTUK MENGUBAH FORMAT DATA DARI JSON KE FORMAT YANG SESUAI DENGAN EMPLOYEE MODEL
  factory InteractionModel.fromJson(Map<String, dynamic> json) =>
      InteractionModel(
        id: json['id'],
        note: json['note'],
        branch: json['branch'],
        namaSales: json['namasales'],
        namaPensiunan: json['namapensiunan'],
        jamKunjungan: json['jam_kunj'],
        keterangan: json['keterangan'],
        cabangAkad: json['cabang_akad'],
        nikMarsit: json['nikmarsit'],
        foto1: json['foto1'],
      );
}
