from jinja2.utils import markupsafe
import hail as hl
import sys
hl.import_vcf(sys.argv[1], array_elements_required=False, force_bgz=True, reference_genome='GRCh38').write('vcf.mt', overwrite=True)
mt = hl.read_matrix_table('vcf.mt')
hl.export_vcf(mt, 'hail.vcf.bgz')
